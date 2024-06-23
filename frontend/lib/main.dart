import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/pages/details/details.dart';
import 'package:frontend/pages/home/home.dart';
import 'package:frontend/service/task_service.dart';

void main() {
  return runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: Modular.routerConfig,
    ); //added by extension
  }
}

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<TaskService>(() => TaskService());
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const MyHomePage());
    r.child('/details/:taskId',
        child: (context) => DetailsPage(taskId: r.args.params['taskId']));
  }
}
