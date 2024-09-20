import 'package:flutter/material.dart';
import 'package:projeto_flutter/models/task_model.dart';
import 'package:projeto_flutter/services/task_service.dart';
import 'package:projeto_flutter/view/form_tasks.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.orange;
      case 'Baixa':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (localIsDone)
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: tasks[index].title.toString(),
                        style: TextStyle(
                          fontSize: 27,
                          color: localIsDone ? Colors.grey : Colors.blue,
                          decoration:
                              localIsDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: localIsDone,
                      onChanged: (value) {
                        if (value != null) {
                          taskService.editTaskByCheckBox(index, value);
                        }
                        setState(() {
                          tasks[index].isDone = value;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  tasks[index].description.toString(),
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(204, 61, 61, 61)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      " ${tasks[index].priority}",
                      style: TextStyle(
                        fontSize: 16,
                        color: getPriorityColor(tasks[index].priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await taskService.deleteTask(index);
                        getAllTasks();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: localIsDone ? Colors.grey : Colors.red,
                      ),
                    ),
                    if (!localIsDone)
                      IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTasks(
                                task: tasks[index],
                                index: index,
                              ),
                            ),
                          ).then((value) => getAllTasks());
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
