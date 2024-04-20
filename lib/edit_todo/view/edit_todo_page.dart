import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/edit_todo/notifier/edit_todo_notifier.dart';
import 'package:flutter_todos/edit_todo/notifier/edit_todo_state.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoPage extends ConsumerWidget {
  const EditTodoPage(this.initialTodo, {super.key});
  final Todo? initialTodo;

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditTodoPage(initialTodo),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(editTodoNotifierProvider.notifier).initTodo(this.initialTodo);
    });
    ref.listen(editTodoNotifierProvider, ((previous, next) {
      if (previous?.status != next.status &&
          next.status == EditTodoStatus.success) {
        Navigator.of(context).pop();
        ref.invalidate(editTodoNotifierProvider);
      }
    }));
    return const EditTodoView();
  }
}

class EditTodoView extends ConsumerWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final status = ref.watch(editTodoNotifierProvider).status;
    final isNewTodo = ref.watch(editTodoNotifierProvider.notifier).isNewTodo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo
              ? l10n.editTodoAddAppBarTitle
              : l10n.editTodoEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editTodoSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => ref.read(editTodoNotifierProvider.notifier).submitToDo(),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [TitleField(), DescriptionField()],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleField extends ConsumerWidget {
  const TitleField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(editTodoNotifierProvider);
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTodoTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        ref.read(editTodoNotifierProvider.notifier).updateTitle(value);
      },
    );
  }
}

class DescriptionField extends ConsumerWidget {
  const DescriptionField();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final state = ref.watch(editTodoNotifierProvider);
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTodoDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        ref.read(editTodoNotifierProvider.notifier).updateDescription(value);
      },
    );
  }
}
