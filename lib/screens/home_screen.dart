import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../services/task_repository.dart';
import 'add_task_screen.dart';

enum TaskFilter { all, pending, completed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<TaskRepository> _repositoryFuture;
  TaskRepository? _repository;
  List<StudyTask> _tasks = [];
  TaskFilter _filter = TaskFilter.pending;

  @override
  void initState() {
    super.initState();
    _repositoryFuture = TaskRepository.create();
    _repositoryFuture.then((repo) {
      _repository = repo;
      _loadTasks();
    });
  }

  void _loadTasks() {
    final repo = _repository;
    if (repo == null) return;
    setState(() {
      _tasks = repo.loadTasks();
    });
  }

  Future<void> _saveTasks() async {
    final repo = _repository;
    if (repo == null) return;
    await repo.saveTasks(_tasks);
    _loadTasks();
  }

  Future<void> _addTask() async {
    final newTask = await Navigator.of(context).push<StudyTask>(
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (newTask == null) return;

    setState(() {
      _tasks.add(newTask);
    });
    await _saveTasks();
  }

  Future<void> _toggleComplete(StudyTask task) async {
    setState(() {
      task.completed = !task.completed;
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(StudyTask task) async {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
    await _saveTasks();
  }

  List<StudyTask> get _filteredTasks {
    switch (_filter) {
      case TaskFilter.pending:
        return _tasks.where((t) => !t.completed).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.completed).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  String get _filterTitle {
    switch (_filter) {
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TaskRepository>(
      future: _repositoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerHighest,
          appBar: AppBar(
            title: const Text('Study TO DO'),
            elevation: 0,
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep your study on track',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<TaskFilter>(
                  segments: const [
                    ButtonSegment(
                      value: TaskFilter.pending,
                      label: Text('Pending'),
                    ),
                    ButtonSegment(
                      value: TaskFilter.completed,
                      label: Text('Done'),
                    ),
                    ButtonSegment(value: TaskFilter.all, label: Text('All')),
                  ],
                  selected: <TaskFilter>{_filter},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _filter = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 18),
                _buildSummaryCard(),
                const SizedBox(height: 14),
                Expanded(child: _buildTaskList()),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _addTask,
            icon: const Icon(Icons.add),
            label: const Text('Add task'),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.completed).length;
    final pending = total - completed;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.95),
            colorScheme.primaryContainer.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(
            label: 'Total',
            value: total,
            valueColor: colorScheme.onPrimary,
            labelColor: colorScheme.onPrimary.withValues(alpha: 0.85),
          ),
          _SummaryItem(
            label: 'Pending',
            value: pending,
            valueColor: colorScheme.onPrimary,
            labelColor: colorScheme.onPrimary.withValues(alpha: 0.85),
          ),
          _SummaryItem(
            label: 'Done',
            value: completed,
            valueColor: colorScheme.onPrimary,
            labelColor: colorScheme.onPrimary.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _filteredTasks;
    if (tasks.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 72,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'No tasks in "$_filterTitle"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first study task.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _deleteTask(task),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => _toggleComplete(task),
              ),
              title: Text(
                task.title,
                style: task.completed
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: task.dueDate != null
                  ? Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 6),
                        Text('Due: ${task.dueDateLabel}'),
                      ],
                    )
                  : null,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTaskDetails(task),
            ),
          ),
        );
      },
    );
  }

  void _showTaskDetails(StudyTask task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (task.description.isNotEmpty) Text(task.description),
              if (task.dueDate != null) ...[
                const SizedBox(height: 8),
                Text('Due: ${task.dueDateLabel}'),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _toggleComplete(task);
                      },
                      icon: Icon(task.completed ? Icons.undo : Icons.check),
                      label: Text(
                        task.completed ? 'Mark as not done' : 'Mark done',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
  });

  final String label;
  final int value;
  final Color? labelColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.bodySmall?.copyWith(color: labelColor)),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: theme.titleLarge?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
