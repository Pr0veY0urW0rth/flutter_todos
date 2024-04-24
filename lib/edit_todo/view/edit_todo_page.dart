import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/edit_todo/notifier/edit_todo_notifier.dart';
import 'package:flutter_todos/edit_todo/notifier/edit_todo_state.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:flutter_todos/l10n/l10n.dart';

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
      ref.watch(editToDoNotifierProvider.notifier).initTodo(this.initialTodo);
    });
    ref.listen(editToDoNotifierProvider, ((previous, next) {
      if (previous?.status != next.status &&
          next.status == EditTodoStatus.success) {
        Navigator.of(context).pop();
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
    final status = ref.watch(editToDoNotifierProvider).status;
    final isNewTodo = ref.watch(editToDoNotifierProvider.notifier).isNewTodo;
    final state = ref.watch(editToDoNotifierProvider);

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
            : () => ref.read(editToDoNotifierProvider.notifier).submitToDo(),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TitleField(
                  localState: state,
                  onChanged: (value) => ref
                      .read(editToDoNotifierProvider.notifier)
                      .updateTitle(value),
                ),
                DescriptionField(
                  localState: state,
                  onChanged: (value) => ref
                      .read(editToDoNotifierProvider.notifier)
                      .updateDescription(value),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleField extends StatelessWidget {
  const TitleField({this.onChanged, required this.localState});

  final EditTodoState localState;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hintText = localState.initialTodo?.title ?? '';
    TextEditingController _controller =
        new TextEditingController(text: localState.title);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: localState.title.toString().length));

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      controller: _controller,
      decoration: InputDecoration(
        enabled: !localState.status.isLoadingOrSuccess,
        labelText: l10n.editTodoTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: onChanged,
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({this.onChanged, required this.localState});
  final EditTodoState localState;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hintText = localState.initialTodo?.description ?? '';
    TextEditingController _controller =
        new TextEditingController(text: localState.description);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: localState.description.toString().length));

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      //initialValue: initialText,
      controller: _controller,
      decoration: InputDecoration(
        enabled: !localState.status.isLoadingOrSuccess,
        labelText: l10n.editTodoDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: onChanged,
    );
  }
}
