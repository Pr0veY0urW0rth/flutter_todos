import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/app/locator.dart';
import 'package:flutter_todos/stats/notifier/stats_state.dart';
import 'package:todos_repository/todos_repository.dart';

class StatsNotifier extends StateNotifier<StatsState> {
  final TodosRepository _todosRepository;
  late StreamSubscription<List<Todo>> _subscription;

  StatsNotifier(this._todosRepository) : super(const StatsState()) {
    _subscribeToTodos();
  }

  Future<void> _subscribeToTodos() async {
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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final statsNotifierProvider = StateNotifierProvider<StatsNotifier, StatsState>(
  (ref) => StatsNotifier(ref.watch(todosRepositoryProvider)),
);
