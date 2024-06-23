class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted = false;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
