import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_state.freezed.dart';

@freezed
class StatsState with _$StatsState {
  const factory StatsState(
      {@Default(StatsStatus.initial) StatsStatus status,
      @Default(0) int completedTodos,
      @Default(0) int activeTodos}) = _StatsState;
}

enum StatsStatus { initial, loading, success, failure }
