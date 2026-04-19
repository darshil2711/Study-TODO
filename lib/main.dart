import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'env_config.dart';
import 'services/task_repository.dart';
import 'viewmodels/task_viewmodel.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure Flutter engine is fully initialized before using async platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Part 4: Load environment variables based on the current build mode
  await EnvConfig.loadEnv();

  // Part 3: Initialize the secure, encrypted local storage repository
  final taskRepository = await TaskRepository.create();

  runApp(
    MultiProvider(
      providers: [
        // Part 1 & 2: Centralized ViewModel provided to the entire widget tree
        ChangeNotifierProvider(create: (_) => TaskViewModel(taskRepository)),
      ],
      child: const StudyToDoApp(),
    ),
  );
}

class StudyToDoApp extends StatelessWidget {
  const StudyToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study TO DO',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
