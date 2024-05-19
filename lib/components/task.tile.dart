import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/task.dart';

import '../provider/tasks.dart';
import '../routes/app_routes.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.task_alt),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.name),
          SizedBox(height: 4),
          Text(
            'Criado em: ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year} ${task.createdAt.hour}:${task.createdAt.minute}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (task.location != null)
            Text(
              'Localização: ${task.location}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.TASK_FORM,
                arguments: task,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Excluir Tarefa'),
                  content: Text('Você tem certeza?'),
                  actions: [
                    TextButton(
                      child: Text('Não'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('Sim'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        Provider.of<Tasks>(context, listen: false).remove(task);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}