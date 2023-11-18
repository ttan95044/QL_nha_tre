// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/screens/add_class/add_sub/add_children_screen.dart';
import 'package:qlnhatre/screens/children/children_infor.dart';
import 'package:qlnhatre/screens/scanner/qr_scanner.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

// ignore: must_be_immutable
class ClassScreen extends StatefulWidget {
  ClassScreen({super.key, required this.documentSnapshot});

  DocumentSnapshot? documentSnapshot;
  @override
  // ignore: library_private_types_in_public_api
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 151, 144),
          title: const Text(
            'Danh sách',
            style: TextStyle(fontFamily: 'NotoSerif', fontSize: 25),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChildrenScreen(
                        idclass: widget.documentSnapshot!['id'],
                      ),
                    ),
                  );
                },
                // ignore: sort_child_properties_last
                child: const Text('Thêm trẻ em'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 15, 161, 142)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(70, 50)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(10)),
                ),
              ),
            )
          ],
        ),
        body: ClassScreenStream(id: widget.documentSnapshot!.id),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 4, 151, 144),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                    id: widget.documentSnapshot!['id'],
                  ),
                ),
              );
            },
            child: const Icon(Icons.qr_code),
          ),
        ));
  }
}

class ClassScreenStream extends StatefulWidget {
  final String id;
  const ClassScreenStream({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClassScreenStreamState createState() => _ClassScreenStreamState();
}

class _ClassScreenStreamState extends State<ClassScreenStream> {
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

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fNChildrenController = TextEditingController();
  final TextEditingController _yOBchildrenController = TextEditingController();
  final TextEditingController _pOBchildrenController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameFController = TextEditingController();
  final TextEditingController _nameMController = TextEditingController();
  final TextEditingController _emailParentController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _gtController = TextEditingController();

  Future<void> _edit([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _codeController.text = documentSnapshot['code'];
      _fNChildrenController.text = documentSnapshot['fnchildren'];
      _gtController.text = documentSnapshot['gt'];
      _yOBchildrenController.text = documentSnapshot['yobchildren'];
      _pOBchildrenController.text = documentSnapshot['pobchildren'];
      _nameFController.text = documentSnapshot['namef'];
      _nameMController.text = documentSnapshot['namem'];
      _emailParentController.text = documentSnapshot['emailparent'];
      _sdtController.text = documentSnapshot['sdt'];
      _addressController.text = documentSnapshot['address'];
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
                    controller: _codeController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa mã số của trẻ',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _fNChildrenController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa họ và tên của trẻ',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _gtController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa giới tính của trẻ',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _yOBchildrenController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa năm sinh của trẻ em',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _pOBchildrenController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa nơi sinh của trẻ em',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _nameFController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa họ và tên của cha',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _nameMController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa họ và tên của mẹ',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _emailParentController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa Email của phụ huynh',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _sdtController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa số điện thoại của phụ huynh',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        labelText: 'Chỉnh sửa địa chỉ',
                        labelStyle: TextStyle(fontSize: 25)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 4, 151, 144)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text(
                      'Cập nhật',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      final String code = _codeController.text;
                      final String fNChildren = _fNChildrenController.text;
                      final String yOBchildren = _yOBchildrenController.text;
                      final String pOBchildren = _pOBchildrenController.text;
                      final String nameF = _nameFController.text;
                      final String nameM = _nameMController.text;
                      final String emailParent = _emailParentController.text;
                      final String sdt = _sdtController.text;
                      final String address = _addressController.text;
                      final String gt = _gtController.text;
                      await FirebaseFirestore.instance
                          .collection('addclass')
                          .doc(widget.id)
                          .collection('addchildren')
                          .doc(documentSnapshot!.id)
                          .update(
                        {
                          "code": code,
                          "fnchildren": fNChildren,
                          "yobchildren": yOBchildren,
                          "pobchildren": pOBchildren,
                          "gt": gt,
                          "namef": nameF,
                          "namem": nameM,
                          "emailparent": emailParent,
                          "sdt": sdt,
                          "address": address,
                        },
                      );
                      _codeController.text = '';
                      _fNChildrenController.text = '';
                      _yOBchildrenController.text = '';
                      _pOBchildrenController.text = '';
                      _nameFController.text = '';
                      _nameMController.text = '';
                      _emailParentController.text = '';
                      _sdtController.text = '';
                      _addressController.text = '';
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
    await FirebaseFirestore.instance
        .collection('addclass')
        .doc(widget.id)
        .collection('addchildren')
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('addclass')
            .doc(widget.id)
            .collection('addchildren')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center();
          }
          count = snapshot.data!.docs.length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Text(
                      'Số trẻ hiện có trong lớp: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 112, 112, 112),
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'NotoSerif',
                      ),
                    ),
                  ],
                ),
              ),
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
                                builder: (_) => ChildrenInfor(
                                  documentSnapshot: documentSnapshot,
                                  idclass: widget.id,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                                  'Mã số:',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 112, 112, 112),
                                                    fontFamily: 'NotoSerif',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  documentSnapshot['code'],
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
                                                  'Họ và tên: ',
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
                                                  documentSnapshot[
                                                      'fnchildren'],
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
                                                  'Số ngày đã lên lớp:',
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
                                                documentSnapshot['quantity'] !=
                                                        null
                                                    ? Text(
                                                        documentSnapshot[
                                                                'quantity']
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'NotoSerif',
                                                        ),
                                                      )
                                                    : const Text(
                                                        '0',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'NotoSerif',
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _edit(documentSnapshot);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Color.fromARGB(
                                                        255, 4, 151, 144),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Thông báo",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'NotoSerif'),
                                                          ),
                                                          content: const Text(
                                                              "Bạn chắc chắn muốn xóa trẻ em?"),
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
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.restore_from_trash,
                                                    color: Color.fromARGB(
                                                        255, 247, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
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
      ),
    );
  }
}
