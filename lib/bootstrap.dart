import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/app/locator.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

void bootstrap({required TodosApi todosApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  setupServiceLocator();
  final todosRepository = TodosRepository(todosApi: todosApi);

  runApp(ProviderScope(child: App(todosRepository: todosRepository)));
}
