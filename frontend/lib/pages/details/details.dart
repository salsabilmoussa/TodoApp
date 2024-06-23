import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailsPage extends StatelessWidget {
  final String taskId;

  const DetailsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Modular.to.navigate('/');
        },
      ),
    ));
  }
}
