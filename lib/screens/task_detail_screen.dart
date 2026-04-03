import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/study_task.dart';
import '../viewmodels/task_viewmodel.dart';

class TaskDetailScreen extends StatelessWidget {
  final StudyTask task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Part 4: Delete feature accessible from detail screen
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final viewModel = Provider.of<TaskViewModel>(
                context,
                listen: false,
              );
              viewModel.deleteTask(task.id);
              Navigator.pop(context); // Go back to home screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted successfully')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  decoration: task.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      label: Text(task.completed ? "Completed" : "Pending"),
                      backgroundColor: task.completed
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                        color: task.completed
                            ? Colors.green.shade900
                            : Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description.isEmpty
                          ? 'No description provided.'
                          : task.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(task.completed ? Icons.undo : Icons.check),
                onPressed: () {
                  final viewModel = Provider.of<TaskViewModel>(
                    context,
                    listen: false,
                  );
                  task.completed = !task.completed;
                  viewModel.updateTask(task);
                  Navigator.pop(context); // Return home after updating
                },
                label: Text(
                  task.completed ? 'Mark as Pending' : 'Mark as Completed',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: task.completed
                      ? Colors.grey.shade600
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
