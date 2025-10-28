import 'package:flutter/material.dart';
import 'package:sqlite_crud_project/presentation/Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        checkboxTheme:CheckboxThemeData(
          shape: const CircleBorder(), //  Circle shape
      side: const BorderSide(color: Colors.purpleAccent),)
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

