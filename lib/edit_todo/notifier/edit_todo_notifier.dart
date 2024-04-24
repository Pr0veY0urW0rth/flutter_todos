import 'package:flutter_todos/app/locator.dart';
import 'package:flutter_todos/edit_todo/notifier/edit_todo_state.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_todo_notifier.g.dart';

@riverpod
class EditToDoNotifier extends _$EditToDoNotifier {
  late TodosRepository _todosRepository;

  @override
  EditTodoState build() {
    _todosRepository = ref.watch(todosRepositoryProvider);
    return EditTodoState(
      initialTodo: null,
      title: '',
      description: '',
    );
  }

  void updateTitle(String title) => state = state.copyWith(title: title);

  void updateDescription(String description) =>
      state = state.copyWith(description: description);

  void submitToDo() async {
    state = state.copyWith(status: EditTodoStatus.loading);
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      state = state.copyWith(status: EditTodoStatus.success);
    } catch (e) {
      state = state.copyWith(status: EditTodoStatus.failure);
    }
  }

  bool get isNewTodo => state.initialTodo == null;

  void initTodo(Todo? todo) async {
    final title = todo != null ? todo.title : '';
    final description = todo != null ? todo.description : '';
    state = state.copyWith(
        initialTodo: todo, description: description, title: title);
  }
}
