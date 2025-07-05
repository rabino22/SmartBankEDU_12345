import 'package:flutter/material.dart';
import 'pages/local_login_page.dart';
import 'pages/local_register_page.dart';
import 'pages/login_page.dart' hide ExamGeneratorPage;
import 'pages/register_page.dart' hide LoginPage, RegisterPage;
import 'pages/exam_generator_page.dart';

void main() {
  runApp(const SmartBankEduApp());
}

class SmartBankEduApp extends StatelessWidget {
  const SmartBankEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartBankEdu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0074B7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0074B7)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/exam': (context) => const ExamGeneratorPage(),
      },
    );
  }
}
