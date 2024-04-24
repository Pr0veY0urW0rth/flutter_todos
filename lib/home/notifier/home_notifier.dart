import 'package:flutter_todos/home/notifier/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return const HomeState();
  }

  void setTab(HomeTab tab) => state = state.copyWith(tab: tab);
}
