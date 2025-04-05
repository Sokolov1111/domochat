
import 'package:domochat/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Основной цвет приложения
          brightness: Brightness.light, // Светлая тема
        ),
        useMaterial3: true, // Включаем Material 3
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder( // Стиль полей ввода
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const RegisterPage(),
    );
  }

}