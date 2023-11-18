import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

late User loggedInUser;

// ignore: must_be_immutable
class ChildrenInfor extends StatefulWidget {
  final String idclass;
  ChildrenInfor(
      {super.key,
      required this.documentSnapshot,
      required this.idclass,
      String? studentId});
  DocumentSnapshot? documentSnapshot;

  @override
  // ignore: library_private_types_in_public_api
  _ChildrenInforState createState() => _ChildrenInforState();
}

class _ChildrenInforState extends State<ChildrenInfor> {
  final _auth = FirebaseAuth.instance;
  int _quantity = 0;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    FirebaseFirestore.instance
        .collection('addclass')
        .doc(widget.idclass)
        .collection('addchildren')
        .doc(widget.documentSnapshot!.id)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        // If the document exists, get the quantity value and update the state
        setState(() {
          _quantity = documentSnapshot.data()!['quantity'] ?? 0;
        });
      }
    });
  }

  void _handleCheckInPressed() {
    setState(() {
      _quantity++;
    });

    // Update the quantity in Firebase.
    FirebaseFirestore.instance
        .collection('addclass')
        .doc(widget.idclass)
        .collection('addchildren')
        .doc(widget.documentSnapshot!.id)
        .update({'quantity': _quantity});
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
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        title: const Text(
          'Thông tin của trẻ',
          style: TextStyle(fontFamily: 'NotoSerif', fontSize: 22),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(widget.documentSnapshot!['imagec']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(
                        image: NetworkImage(
                            widget.documentSnapshot!['imageUrlQR']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Mã số:',
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.documentSnapshot!['code'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Họ và tên:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['fnchildren'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Giới tính:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['gt'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Năm sinh:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['yobchildren'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Nơi sinh:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['pobchildren'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Số ngày đã lên lớp:",
                              style: TextStyle(
                                fontSize: 23,
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 112, 112, 112),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            widget.documentSnapshot!['quantity'] != null
                                ? Text(
                                    widget.documentSnapshot!['quantity']
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSerif',
                                    ),
                                  )
                                : const Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSerif',
                                    ),
                                  ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _handleCheckInPressed,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 4, 151, 144)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                          ),
                          child: const Text(
                            'Điểm danh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Thông tin của phụ huynh',
                          style: TextStyle(
                            fontSize: 27,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 151, 144),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image(
                          image:
                              NetworkImage(widget.documentSnapshot!['imagef']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Họ và tên cha:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['namef'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image(
                          image:
                              NetworkImage(widget.documentSnapshot!['imagem']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Họ và tên mẹ:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['namem'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Email:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['emailparent'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Số điện thoại:",
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),
                        Text(
                          widget.documentSnapshot!['sdt'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontFamily: 'NotoSerif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Địa chỉ:",
                              style: TextStyle(
                                fontSize: 23,
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 112, 112, 112),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                widget.documentSnapshot!['address'],
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontFamily: 'NotoSerif',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
