import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeTab { todos, stats }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({@Default(HomeTab.todos) HomeTab tab}) = _HomeState;
}
