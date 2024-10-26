import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackwithinfy/Authentication/login_page.dart';
import 'package:hackwithinfy/Authentication/sign_up_page.dart';
import 'package:hackwithinfy/Onboarding_Questions/onboarding_pages.dart';
import 'package:hackwithinfy/Screens/body.dart';
import 'package:hackwithinfy/Screens/home_page.dart';
import 'package:hackwithinfy/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  _requestPermission();
  runApp(MyApp());
}

void _requestPermission() async {
  final status = await Permission.sms.status;
  if (!status.isGranted) {
    await Permission.sms.request();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<String> questions = [
    "How would you rate your overall health?",
    "How often do you engage in physical activity or exercise?",
    "Do you have any existing medical conditions (e.g., diabetes, hypertension, asthma)?",
    "What is your age group?",
    "How many hours of sleep do you typically get per night?",
    "How often do you feel stressed or anxious?",
    "Do you consume any intoxicants substances?",
    "How often do you get a health checkup?",
    "How many times a day do you typically eat meals (including snacks)?",
    "Is there anything you want to share about your health condition?",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          // _onboardinQuestions(questions[0])
          _handleAuthState(),
    );
  }
}

Widget _onboardinQuestions(String question) {
  User? user = FirebaseAuth.instance.currentUser;
  return OnboardingPage(
      index: 0, question: question, userEmail: user!.email.toString());
}

Widget _handleAuthState() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const LoginPage();
  } else {
    return DashboardPage();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
