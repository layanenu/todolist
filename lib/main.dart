import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/tasks.dart';
import 'package:todolist/routes/app_routes.dart';
import 'package:todolist/screens/task_list.dart';

import 'screens/task_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Tasks(),
        )
      ], 
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          routes: {
            AppRoutes.HOME: (_) => TaskList(),
            AppRoutes.TASK_FORM: (_) => TaskForm()
          },
        ),
    );
  }
}