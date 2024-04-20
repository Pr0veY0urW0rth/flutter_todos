import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register services
  final sharedPreferencesService = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton(sharedPreferencesService);
}

final todosApiProvider = Provider<TodosApi>((ref) =>
    LocalStorageTodosApi(plugin: serviceLocator.get<SharedPreferences>()));

final todosRepositoryProvider = Provider<TodosRepository>((ref) {
  final todosApi = ref.watch(todosApiProvider);
  return TodosRepository(todosApi: todosApi);
});
