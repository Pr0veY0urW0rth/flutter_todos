import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locator.g.dart';

class AppSharedPrefs {
  static AppSharedPrefs? _instance;
  static SharedPreferences? _prefs;

  factory AppSharedPrefs() {
    if (_instance == null) {
      throw Exception('AppSharedPrefs is not initialized. '
          'Please call AppSharedPrefs.ensureInitialized before.');
    }
    return _instance!;
  }

  const AppSharedPrefs._();

  static ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
    _instance ??= const AppSharedPrefs._();
  }
}

final sharedPreferences =
    Provider<SharedPreferences>((_) => AppSharedPrefs._prefs!);

@Riverpod(keepAlive: true)
TodosApi todosApi(TodosApiRef ref) {
  return LocalStorageTodosApi(plugin: ref.watch(sharedPreferences));
}

@Riverpod(keepAlive: true)
TodosRepository todosRepository(TodosRepositoryRef ref) {
  final todosApi = ref.watch(todosApiProvider);
  return TodosRepository(todosApi: todosApi);
}
