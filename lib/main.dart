import 'package:flutter/material.dart';
import 'package:final_project/config/app_config.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensures async works
  await AppConfig.load(); // Load .env variables
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Text("data")
    );
  }
}

