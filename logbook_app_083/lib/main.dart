import 'package:flutter/material.dart';
// Sesuaikan path import dengan struktur folder baru
import 'package:logbook_app_083/features/onboarding/onboarding_view.dart';
import 'package:logbook_app_083/features/auth/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogBook App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const OnboardingView(),
      routes: {
        '/login': (context) => const LoginView(),
      },
    );
  }
}