import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:flutter_todos/home/home.dart';
import 'package:flutter_todos/stats/stats.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(homeNotifierProvider).tab;

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [TodosOverviewPage(), StatsPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todos,
              icon: const Icon(Icons.list_rounded),
              onPressed: () =>
                  ref.read(homeNotifierProvider.notifier).setTab(HomeTab.todos),
            ),
            HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats,
              icon: const Icon(Icons.show_chart_rounded),
              onPressed: () =>
                  ref.read(homeNotifierProvider.notifier).setTab(HomeTab.stats),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTabButton extends StatelessWidget {
  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final VoidCallback? onPressed;

  const HomeTabButton(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      iconSize: 32,
      onPressed: onPressed,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
    );
  }
}
