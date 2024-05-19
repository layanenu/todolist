import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/components/task.tile.dart';
import 'package:todolist/provider/tasks.dart';
import 'package:todolist/routes/app_routes.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final Tasks tasks = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.TASK_FORM);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight - 50,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.count,
            itemBuilder: (ctx, i) => TaskTile(tasks.byIndex(i)),
          ),
        ),
      ),
    );
  }
}