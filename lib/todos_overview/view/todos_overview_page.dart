import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class TodosOverviewPage extends ConsumerWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final todosState = ref.watch(todosOverwiewNotifierProvider);
    final filter = ref.watch(todosOverwiewNotifierProvider).filter;

    ref.listen(
      todosOverwiewNotifierProvider.select((value) => value),
      ((previous, next) {
        if (todosState.status == TodosOverviewStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.todosOverviewErrorSnackbarText),
              ),
            );
        }
        if (previous?.lastDeletedTodo != next.lastDeletedTodo &&
            next.lastDeletedTodo != null) {
          final deletedTodo = todosState.lastDeletedTodo!;
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  l10n.todosOverviewTodoDeletedSnackbarText(
                    deletedTodo.title,
                  ),
                ),
                action: SnackBarAction(
                  label: l10n.todosOverviewUndoDeletionButtonText,
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    ref
                        .read(todosOverwiewNotifierProvider.notifier)
                        .undoDeletionRequest();
                  },
                ),
              ),
            );
        }
      }),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todosOverviewAppBarTitle),
        actions: [
          TodosOverviewFilterButton(
            activeFilter: filter,
            onSelected: (filter) => ref
                .read(todosOverwiewNotifierProvider.notifier)
                .changeFilter(filter),
          ),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: todosState.todos.isEmpty
          ? todosState.status == TodosOverviewStatus.loading
              ? const Center(child: CupertinoActivityIndicator())
              : todosState.status != TodosOverviewStatus.success
                  ? const SizedBox()
                  : Center(
                      child: Text(
                        l10n.todosOverviewEmptyText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
          : CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final todo in todosState.filteredTodos)
                    TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        ref
                            .read(todosOverwiewNotifierProvider.notifier)
                            .todoToggleCompletion(todo, isCompleted);
                      },
                      onDismissed: (_) {
                        ref
                            .read(todosOverwiewNotifierProvider.notifier)
                            .todoDelete(todo);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditTodoPage.route(initialTodo: todo),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
