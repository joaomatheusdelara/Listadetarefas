import 'package:flutter/material.dart';
import 'package:projeto_flutter/models/task_model.dart';
import 'package:projeto_flutter/services/task_service.dart';

class CreateTasks extends StatefulWidget {
  final Task? task;
  final int? index;
  const CreateTasks({super.key, this.task, this.index});

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String _priority = "Baixa";
  TaskService tasksService = TaskService();

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _priority = widget.task!.priority;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.task != null ? 'Editar Tarefa' : 'Criar Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* Título não preenchido!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text('Título'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* Descrição não preenchida!';
                    }
                    return null;
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                    label: Text('Descrição'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Prioridade", style: TextStyle(fontSize: 16)),
                    RadioListTile(
                      title: Text("Baixa"),
                      value: "Baixa",
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Média"),
                      value: "Média",
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Alta"),
                      value: "Alta",
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String titleNewTask = _titleController.text;
                    String descriptionNewTask = _descriptionController.text;
                    String priorityNewTask = _priority;

                    if (widget.task != null && widget.index != null) {
                      await tasksService.editTask(
                        widget.index!,
                        titleNewTask,
                        descriptionNewTask,
                        false, 
                        priorityNewTask,
                      );
                    } else {

                      await tasksService.saveTask(
                        titleNewTask,
                        descriptionNewTask,
                        false, 
                        priorityNewTask,
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task != null
                    ? 'Alterar Tarefa'
                    : 'Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
