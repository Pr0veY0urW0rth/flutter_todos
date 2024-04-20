import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/stats/notifier/stats_notifier.dart';
import 'package:flutter_todos/stats/notifier/stats_state.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsNotifierProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsAppBarTitle),
      ),
      body: statsState.status == StatsStatus.success
          ? Column(
              children: [
                ListTile(
                  key: const Key('statsView_completedTodos_listTile'),
                  leading: const Icon(Icons.check_rounded),
                  title: Text(l10n.statsCompletedTodoCountLabel),
                  trailing: Text(
                    '${statsState.completedTodos}',
                    style: textTheme.headlineSmall,
                  ),
                ),
                ListTile(
                  key: const Key('statsView_activeTodos_listTile'),
                  leading: const Icon(Icons.radio_button_unchecked_rounded),
                  title: Text(l10n.statsActiveTodoCountLabel),
                  trailing: Text(
                    '${statsState.activeTodos}',
                    style: textTheme.headlineSmall,
                  ),
                ),
              ],
            )
          : statsState.status == StatsStatus.loading
              ? CircularProgressIndicator()
              : statsState.status == StatsStatus.failure
                  ? Text('Failure on loading')
                  : null,
    );
  }
}
