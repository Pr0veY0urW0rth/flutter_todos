import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

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

final sharedPrefs = Provider<SharedPreferences>((_) => AppSharedPrefs._prefs!);

final todosApiProvider = Provider<TodosApi>(
    (ref) => LocalStorageTodosApi(plugin: ref.watch(sharedPrefs)));

final todosRepositoryProvider = Provider<TodosRepository>((ref) {
  final todosApi = ref.watch(todosApiProvider);
  return TodosRepository(todosApi: todosApi);
});
