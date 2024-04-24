import 'dart:async';

import 'package:flutter_todos/app/locator.dart';
import 'package:flutter_todos/todos_overview/models/todos_view_filter.dart';
import 'package:flutter_todos/todos_overview/notifier/todos_overview_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_notifier.g.dart';

@riverpod
class TodosOverviewNotifier extends _$TodosOverviewNotifier {
  late TodosRepository _todosRepository;
  late StreamSubscription<List<Todo>> _subscription;

  @override
  TodosOverviewState build() {
    _todosRepository = ref.watch(todosRepositoryProvider);

    return const TodosOverviewState();
  }

  Future<void> subscribeToTodos() async {
    state = state.copyWith(status: () => TodosOverviewStatus.loading);
    try {
      _subscription = _todosRepository.getTodos().listen((todos) {
        state = state.copyWith(
          status: () => TodosOverviewStatus.success,
          todos: () => todos,
        );
      }, onError: (error) {
        state = state.copyWith(status: () => TodosOverviewStatus.failure);
      });
    } catch (e) {
      state = state.copyWith(status: () => TodosOverviewStatus.failure);
    }
  }

  Future<void> todoToggleCompletion(Todo todo, bool isCompleted) async {
    final newTodo = todo.copyWith(isCompleted: isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> todoDelete(Todo todo) async {
    state = state.copyWith(lastDeletedTodo: () => todo);
    await _todosRepository.deleteTodo(todo.id);
  }

  Future<void> undoDeletionRequest() async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    state = state.copyWith(lastDeletedTodo: () => null);
    await _todosRepository.saveTodo(todo);
  }

  void changeFilter(TodosViewFilter filter) {
    state = state.copyWith(filter: () => filter);
  }

  Future<void> toggleAllRequested() async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> clearCompletedRequested() async {
    await _todosRepository.clearCompleted();
  }

  void dispose() {
    _subscription.cancel();
  }
}
