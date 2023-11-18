import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/button/button.dart';
import 'package:qlnhatre/screens/home/home_screen.dart';
import 'package:qlnhatre/screens/register/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  // ignore: unnecessary_new
  TextEditingController emailController = new TextEditingController();
  // ignore: unnecessary_new
  TextEditingController passwordController = new TextEditingController();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/school.png'),
              ),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromARGB(255, 4, 151, 144),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nhập Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nhập mặt khẩu',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Button(
                title: 'Đăng Nhập',
                colour: const Color.fromARGB(255, 4, 151, 144),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final users = await _auth.signInWithEmailAndPassword(
                        email: email!, password: password!);
                    // ignore: unnecessary_null_comparison
                    if (users != null) {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString('email', emailController.text);
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, HomeScreen.id);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Đăng nhập thành công !!!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'NotoSerif'),
                      )));
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sai tài khoản hoặc mật khẩu !!!',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontFamily: 'NotoSerif'),
                        ),
                      ),
                    );
                    // print(e);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn chưa có tài khoản: '),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Register.id);
                    },
                    child: const Text(
                      'Đăng ký tài khoản',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
