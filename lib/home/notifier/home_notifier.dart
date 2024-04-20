import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/home/notifier/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
  void setTab(HomeTab tab) => state = state.copyWith(tab: tab);
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());
