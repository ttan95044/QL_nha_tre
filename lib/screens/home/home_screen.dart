import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/button/sidebar.dart';
import 'package:qlnhatre/screens/class/class_screen.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final seasonTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? seasonText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print('Imformation of user: $user');
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        title: const Text(
          'Danh sách các lớp học',
          style: TextStyle(fontFamily: 'NotoSerif', fontSize: 25),
        ),
      ),
      body: const HomeScreenStream(),
    );
  }
}

class HomeScreenStream extends StatefulWidget {
  const HomeScreenStream({Key? key}) : super(key: key);

  @override
  State<HomeScreenStream> createState() => _HomeScreenStreamState();
}

class _HomeScreenStreamState extends State<HomeScreenStream> {
  final TextEditingController _classnameController = TextEditingController();

  final TextEditingController _quantityController = TextEditingController();

  final TextEditingController _teacherController = TextEditingController();

  final CollectionReference _addclass =
      FirebaseFirestore.instance.collection('addclass');

  Future<void> _edit([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _classnameController.text = documentSnapshot['classname'];
      _teacherController.text = documentSnapshot['teacher'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _classnameController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa tên lớp',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _teacherController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa tên giáo viên',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 4, 151, 144)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text(
                      'Cập nhật',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final String classname = _classnameController.text;
                      final String quantity = _quantityController.text;
                      final String teacher = _teacherController.text;
                      await _addclass.doc(documentSnapshot!.id).update(
                        {
                          "classname": classname,
                          "teacher": teacher,
                        },
                      );
                      _classnameController.text = '';
                      _quantityController.text = '';
                      _teacherController.text = '';
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(String productId) async {
    await _addclass.doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('addclass').orderBy('timestamp').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, int index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return loggedInUser.email == documentSnapshot['email']
                      ? GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClassScreen(
                                documentSnapshot: documentSnapshot,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 110,
                              width: 370,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Tên lớp:',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 112, 112, 112),
                                                  fontFamily: 'NotoSerif',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                documentSnapshot['classname'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'NotoSerif',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Giáo viên: ',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 112, 112, 112),
                                                  fontFamily: 'NotoSerif',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                documentSnapshot['teacher'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'NotoSerif',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _edit(documentSnapshot);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Color.fromARGB(
                                                        255, 4, 151, 144),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Xóa Lớp?",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'NotoSerif'),
                                                          ),
                                                          content: const Text(
                                                              "Bạn chắc chắn muốn xóa lớp?"),
                                                          actions: [
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                'Không',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                _delete(
                                                                    documentSnapshot
                                                                        .id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                "Đồng ý",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  child: Icon(
                                                    Icons.restore_from_trash,
                                                    color: Color.fromARGB(
                                                        255, 247, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
