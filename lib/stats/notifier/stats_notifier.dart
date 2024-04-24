import 'dart:async';
import 'package:flutter_todos/app/locator.dart';
import 'package:flutter_todos/stats/notifier/stats_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_notifier.g.dart';

@riverpod //(keepAlive: true)
class StatsNotifier extends _$StatsNotifier {
  late TodosRepository _todosRepository;
  late StreamSubscription<List<Todo>> _subscription;

  @override
  StatsState build() {
    _todosRepository = ref.watch(todosRepositoryProvider);
    return const StatsState();
  }

  Future<void> subscribeToTodos() async {
    state = state.copyWith(status: StatsStatus.loading);
    try {
      _subscription = _todosRepository.getTodos().listen((todos) {
        state = state.copyWith(
          status: StatsStatus.success,
          completedTodos: todos.where((todo) => todo.isCompleted).length,
          activeTodos: todos.where((todo) => !todo.isCompleted).length,
        );
      }, onError: (error) {
        state = state.copyWith(status: StatsStatus.failure);
      });
    } catch (e) {
      state = state.copyWith(status: StatsStatus.failure);
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
