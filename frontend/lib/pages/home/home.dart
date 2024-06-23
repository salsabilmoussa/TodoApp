import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/pages/home/widgets/search.dart';
import 'package:frontend/service/task_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController updateTitleController = TextEditingController();
  final TextEditingController updateDescriptionController =
      TextEditingController();
  List<Task> tasks = [];
  List<Task> tasksCopy = [];

  final TaskService taskService = Modular.get<TaskService>();

  @override
  void initState() {
    super.initState();
    taskService.getTasks().then((taskList) {
      setState(() {
        tasks = taskList;
        tasksCopy = tasks;
      });
    });
  }

  void onUpdate(List<Task> newTasks) {
    setState(() {
      tasks = newTasks;
      tasksCopy = newTasks;
    });
  }

  void onChanged(bool? newValue, int index) {
    setState(() {
      tasks[index].isCompleted = newValue ?? false;
      taskService.updateStatus(
          tasks[index].id, tasks[index].isCompleted, tasks, onUpdate);
    });
  }

  void searchTasks(String s) {
    tasks = tasksCopy;
    setState(() {
      tasks = tasks.where((task) => task.title.contains(s)).toList();
    });
  }

  void reorder(int oldIndex, int newIndex) {
    tasks = tasksCopy;
    setState(() {
      if (newIndex > oldIndex) {
        newIndex--;
      }
      final task = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, task);
      taskService.updateOrder(tasks, onUpdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 228, 254),
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 197, 146, 203),
      ),
      body: Column(
        children: [
          SearchSection(
            onSearch: (s) {
              searchTasks(s);
            },
          ),
          Expanded(
            child: ReorderableListView(
              children: [
                for (int i = 0; i < tasks.length; i++)
                  GestureDetector(
                    key: ValueKey(tasks[i]),
                    onTap: () {
                      Modular.to.navigate('/details/${tasks[i].id}');
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                taskService.deleteTask(
                                    context, tasks[i].id, tasks, onUpdate);
                              },
                              backgroundColor:
                                  const Color.fromARGB(255, 222, 183, 226),
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 247, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: tasks[i].isCompleted,
                                onChanged: (newValue) {
                                  onChanged(newValue, i);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  tasks[i].title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showUpdateTaskDialog(context, tasks[i]);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              onReorder: (oldIndex, newIndex) => reorder(oldIndex, newIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 254, 247, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 254, 247, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                titleController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskService.addTask(
                    titleController, descriptionController, tasks, onUpdate);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showUpdateTaskDialog(BuildContext context, Task task) {
    updateTitleController.text = task.title;
    updateDescriptionController.text = task.description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: updateTitleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 254, 247, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: updateDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 254, 247, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 197, 146, 203),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                updateTitleController.clear();
                updateDescriptionController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskService.updateTask(task.id, updateTitleController,
                    updateDescriptionController, tasks, onUpdate);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
