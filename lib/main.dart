import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/screens/add_class/add_class_screen.dart';
import 'package:qlnhatre/screens/home/home_screen.dart';
import 'package:qlnhatre/screens/login/login_screen.dart';
import 'package:qlnhatre/screens/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        Register.id: (context) => const Register(),
        HomeScreen.id: (context) =>  const HomeScreen(),
        AddClassScreen.id:(context) => const AddClassScreen(),
      },
    );
  }
}
