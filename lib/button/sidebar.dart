import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/screens/add_class/add_class_screen.dart';

late User loggedInUser;

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  DocumentSnapshot? documentSnapshot;

  SideBar({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  User? user = FirebaseAuth.instance.currentUser;

  String fullname = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        fullname = value.data()?['fullname'] ?? '';
        email = value.data()?['email'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(fullname),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 4, 151, 144),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: const Text('Thêm lớp'),
            onTap: () {
              Navigator.pushNamed(context, AddClassScreen.id);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
