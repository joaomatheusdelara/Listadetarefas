class Task {
  String? title;
  String? description;
  bool? isDone;
  String priority;

  Task({this.title, this.description, this.isDone, required this.priority});

  Map toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': priority
    };
  }

  Task.fromJson(Map<String, dynamic> json)
      : priority = json['priority'] ?? 'Baixa' {
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'];
  }
}
