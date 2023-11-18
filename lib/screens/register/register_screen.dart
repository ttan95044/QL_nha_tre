import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qlnhatre/model/users_model.dart';
import 'package:qlnhatre/screens/login/login_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  static const String id = 'register_screen';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

  // ignore: unnecessary_new
  final fullNameEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final emailEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final addressEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final positionEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final passwordEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //full name field
    final fullNamefield = TextFormField(
      autofocus: false,
      controller: fullNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        // ignore: unnecessary_new
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Không được để trống");
        }
        if (!regex.hasMatch(value)) {
          return ("Nhập tên hợp lệ (Tối thiểu 3 ký tự)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Họ và Tên',
      ),
    );

    // address
    final addressfield = TextFormField(
      autofocus: false,
      controller: addressEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        // ignore: unnecessary_new
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Không được để trống");
        }
        if (!regex.hasMatch(value)) {
          return ("(Tối thiểu 3 ký tự)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ',
      ),
    );

    //position
    final positionfield = TextFormField(
      autofocus: false,
      controller: positionEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        // ignore: unnecessary_new
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Không được để trống");
        }
        if (!regex.hasMatch(value)) {
          return ("(Tối thiểu 3 ký tự)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Chức vụ',
      ),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Vui lòng nhập email của bạn");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Vui lòng nhập email hợp lệ");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email của bạn',
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        // ignore: unnecessary_new
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Mật khẩu được yêu cầu để đăng nhập");
        }
        if (!regex.hasMatch(value)) {
          return ("Nhập mật khẩu hợp lệ (tối thiểu 6 ký tự)");
        }
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Mặt khẩu',
      ),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Incompatible Password";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Nhập lại mặt khẩu',
      ),
    );

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 4, 151, 144),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "Đăng Ký",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:  Color.fromARGB(255, 4, 151, 144),),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        'Đăng ký tài khoản',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:  Color.fromARGB(255, 4, 151, 144),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    fullNamefield,
                    const SizedBox(height: 10),
                    emailField,
                    const SizedBox(height: 10),
                    addressfield,
                    const SizedBox(height: 10),
                    positionfield,
                    const SizedBox(height: 10),
                    passwordField,
                    const SizedBox(height: 10),
                    confirmPasswordField,
                    const SizedBox(height: 20),
                    signUpButton,
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError(
          // ignore: body_might_complete_normally_catch_error
          (e) {
            Fluttertoast.showToast(msg: e!.message);
          },
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        // ignore: avoid_print
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullname = fullNameEditingController.text;
    userModel.address = addressEditingController.text;
    userModel.position = positionEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Tài khoản được tạo thành công");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
