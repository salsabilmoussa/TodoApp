import 'package:flutter/material.dart';
import 'package:frontend/model/task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  void addTask(
      TextEditingController titleController,
      TextEditingController descriptionController,
      List<Task> tasks,
      Function(List<Task>) onUpdate) async {
    String title = titleController.text;
    String description = descriptionController.text;

    String jsonBody = json.encode({'title': title, 'description': description});

    var response = await http.post(
      Uri.parse('http://192.168.56.1:8000/task/new'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      List<Task> taskList = await getTasks();
      onUpdate(taskList);
    } else {
      print('Failed to add task');
    }
  }

  Future<List<Task>> getTasks() async {
    var url = Uri.parse('http://192.168.56.1:8000/task/tasks');

    var response = await http.get(url);

    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((task) => Task.fromJson(task)).toList();
  }

  void deleteTask(BuildContext context, String taskId, List<Task> tasks,
      Function(List<Task>) onUpdate) async {
    var url = Uri.parse('http://192.168.56.1:8000/task/delete/$taskId');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<Task> taskList = await getTasks();
      onUpdate(taskList);
    } else {
      print('Failed to delete task');
    }
  }

  void updateTask(
      String taskId,
      TextEditingController titleController,
      TextEditingController descriptionController,
      List<Task> tasks,
      Function(List<Task>) onUpdate) async {
    String title = titleController.text;
    String description = descriptionController.text;

    String jsonBody = json.encode({'title': title, 'description': description});

    var response = await http.put(
      Uri.parse('http://192.168.56.1:8000/task/update/$taskId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      List<Task> taskList = await getTasks();
      onUpdate(taskList);
      titleController.clear();
      descriptionController.clear();
    } else {
      print('Failed to update task');
    }
  }

  void updateStatus(String taskId, bool isCompleted, List<Task> tasks,
      Function(List<Task>) onUpdate) async {
    String jsonBody = json.encode({'isCompleted': isCompleted});

    var response = await http.put(
      Uri.parse('http://192.168.56.1:8000/task/update_status/$taskId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      List<Task> taskList = await getTasks();
      onUpdate(taskList);
    } else {
      print('Failed to update task');
    }
  }

  void updateOrder(List<Task> tasks, Function(List<Task>) onUpdate) async {
    var url = Uri.parse('http://192.168.56.1:8000/task/update_order');
    List<Map<String, dynamic>> tasksJson =
        tasks.map((task) => task.toJson()).toList();

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(tasksJson),
    );
    if (response.statusCode == 200) {
      List<Task> taskList = await getTasks();
      onUpdate(taskList);
      print('Reorder successful');
    } else {
      print('Failed');
    }
  }
}
