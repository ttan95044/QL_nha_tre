import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({Key? key}) : super(key: key);

  static const String id = 'addclassname';

  @override
  // ignore: library_private_types_in_public_api
  _AddClassScreenState createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  String? messageText;
  String? classname, id;
  String? teacher;

  final _formKey = GlobalKey<FormState>();

  // ignore: unnecessary_new
  final classnameEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final teacherEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      // ignore: await_only_futures
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // ignore: avoid_print
        print('User: $user');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classnamebt = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: classnameEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          classname = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Tên của lớp',
        ),
      ),
    );

    final teacherbt = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: teacherEditingController,
        validator: (value) =>
            ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          teacher = value.toString();
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Giáo viên phụ trách',
        ),
      ),
    );

    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 4, 151, 144),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            addClass();
          },
          child: const Text(
            "Lưu",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'NotoSerif'),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 4, 151, 144),
          ),
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
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/school.png'),
                    ),
                    const Center(
                      child: Text(
                        'Thêm lớp học',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 151, 144),
                        ),
                      ),
                    ),
                    classnamebt,
                    const SizedBox(height: 15),
                    teacherbt,
                    const SizedBox(height: 15),
                    addButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addClass() {
    id = _firestore.collection('addclass').doc().id;
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      _firestore.collection('addclass').doc(id).set({
        'timestamp': DateTime.now(),
        'email': loggedInUser.email,
        'classname': classname,
        'teacher': teacher,
        'id': id,
      });
      EasyLoading.showSuccess('Add Successful!');
      Navigator.of(context).pop();
    } else {
      EasyLoading.showError('Can\'t Add Product!');
    }
  }
}
