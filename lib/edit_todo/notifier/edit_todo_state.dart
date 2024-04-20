import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_state.freezed.dart';

@freezed
class EditTodoState with _$EditTodoState {
  const factory EditTodoState({
    @Default(EditTodoStatus.initial) EditTodoStatus status,
    @Default(null) Todo? initialTodo,
    @Default('') String title,
    @Default('') String description,
  }) = _EditTodoState;
}

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}
