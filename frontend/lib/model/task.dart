import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

@JsonSerializable()
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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
