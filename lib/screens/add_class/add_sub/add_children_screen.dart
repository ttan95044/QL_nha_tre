// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qlnhatre/button/qr_code.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class AddChildrenScreen extends StatefulWidget {
  final String idclass;
  const AddChildrenScreen({
    Key? key,
    required this.idclass,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddChildrenScreenState createState() => _AddChildrenScreenState();
}

class _AddChildrenScreenState extends State<AddChildrenScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  String? messageText;
  String? fNChildren, yOBchildren, pOBchildren, address, id;
  String? nameM, nameF, emailParent, gt, quantity;
  String? imageUrlC;
  String? imageUrlF;
  String? imageUrlM,code, sdt;
  

  final _formKey = GlobalKey<FormState>();

  // ignore: unnecessary_new
  final codeEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final fNChildrenEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final yOBchildrenEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final pOBchildrenEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final addressEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final nameMEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final nameFEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final emailParentEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final sdtEditingController = new TextEditingController();
  // ignore: unnecessary_new
  final gtEditingController = new TextEditingController();

  @override
  void dispose() {
    codeEditingController.dispose();
    fNChildrenEditingController.dispose();
    yOBchildrenEditingController.dispose();
    pOBchildrenEditingController.dispose();
    addressEditingController.dispose();
    nameMEditingController.dispose();
    nameFEditingController.dispose();
    emailParentEditingController.dispose();
    sdtEditingController.dispose();
    gtEditingController.dispose();
    super.dispose();
  }

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
        // print('User: $user');
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final codebt = TextFormField(
      textAlign: TextAlign.center,
      controller: codeEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType:
          TextInputType.text, 
      onChanged: (value) {
        // Convert input string to an int
        code = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Mã của trẻ',
      ),
    );

    final fNChildrenbt = TextFormField(
      textAlign: TextAlign.center,
      controller: fNChildrenEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        fNChildren = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Họ và tên của trẻ em',
      ),
    );

    final gtbt = TextFormField(
      textAlign: TextAlign.center,
      controller: gtEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        gt = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Giới tính của trẻ',
      ),
    );

    final yOBchildrenbt = TextFormField(
      textAlign: TextAlign.center,
      controller: yOBchildrenEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        yOBchildren = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Năm sinh',
      ),
    );

    final pOBchildrenbt = TextFormField(
      textAlign: TextAlign.center,
      controller: pOBchildrenEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        pOBchildren = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nơi sinh',
      ),
    );

    final addressbt = TextFormField(
      textAlign: TextAlign.center,
      controller: addressEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        address = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ',
      ),
    );

    final nameFbt = TextFormField(
      textAlign: TextAlign.center,
      controller: nameFEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        nameF = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Họ tên của Cha',
      ),
    );
    final nameMbt = TextFormField(
      textAlign: TextAlign.center,
      controller: nameMEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        nameM = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Họ tên của Mẹ',
      ),
    );
    final emailParentbt = TextFormField(
      textAlign: TextAlign.center,
      controller: emailParentEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Vui lòng nhập email của bạn");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Vui lòng nhập email hợp lệ");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onChanged: (value) {
        emailParent = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
    );
    final sdtbt = TextFormField(
      textAlign: TextAlign.center,
      controller: sdtEditingController,
      validator: (value) =>
          ((value?.length ?? 0) < 1 ? 'Không Được Để Trống.' : null),
      keyboardType:
          TextInputType.text, 
      onChanged: (value) {
        // Convert input string to an int
        sdt = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
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
          addChildren();
          codeEditingController.clear();
          fNChildrenEditingController.clear();
          yOBchildrenEditingController.clear();
          pOBchildrenEditingController.clear();
          addressEditingController.clear();
          nameMEditingController.clear();
          nameFEditingController.clear();
          emailParentEditingController.clear();
          sdtEditingController.clear();
        },
        child: const Text(
          "Lưu",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 4, 151, 144)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Thêm thông tin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSerif',
                        color: Color.fromARGB(255, 4, 151, 144),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 4, 151, 144),
                      radius: 70, // độ lớn của avatar
                      backgroundImage:
                          (imageUrlC != null) ? NetworkImage(imageUrlC!) : null,
                      child: (imageUrlC == null)
                          ? const Icon(
                              Icons.person,
                              size: 30,
                            )
                          : null,
                    ),
                    SizedBox(
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        onPressed: uploadImageC,
                      ),
                    ),
                    const Text(
                      'Thông tin trẻ em',
                      style: TextStyle(
                          fontFamily: 'NotoSerif',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 151, 144)),
                    ),
                    codebt,
                    const SizedBox(height: 10),
                    fNChildrenbt,
                    const SizedBox(height: 10),
                    yOBchildrenbt,
                    const SizedBox(height: 10),
                    pOBchildrenbt,
                    const SizedBox(height: 10),
                    gtbt,
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Thông tin phụ huynh',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 151, 144),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 4, 151, 144),
                              radius: 70, // độ lớn của avatar
                              backgroundImage: (imageUrlF != null)
                                  ? NetworkImage(imageUrlF!)
                                  : null,
                              child: (imageUrlF == null)
                                  ? const Icon(
                                      Icons.person,
                                      size: 30,
                                    )
                                  : null,
                            ),
                            SizedBox(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                onPressed: uploadImageF,
                              ),
                            ),
                            const Text(
                              'Hình ảnh cha',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 151, 144),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 4, 151, 144),
                              radius: 70, // độ lớn của avatar
                              backgroundImage: (imageUrlM != null)
                                  ? NetworkImage(imageUrlM!)
                                  : null,
                              child: (imageUrlM == null)
                                  ? const Icon(
                                      Icons.person,
                                      size: 30,
                                    )
                                  : null,
                            ),
                            SizedBox(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                onPressed: uploadImageM,
                              ),
                            ),
                            const Text(
                              'Hình ảnh mẹ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 151, 144),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    nameFbt,
                    const SizedBox(height: 10),
                    nameMbt,
                    const SizedBox(height: 10),
                    emailParentbt,
                    const SizedBox(height: 10),
                    sdtbt,
                    const SizedBox(height: 10),
                    addressbt,
                    const SizedBox(height: 10),
                    addButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addChildren() async {
    // Tạo id mới cho học sinh
    final id = _firestore
        .collection('addclass')
        .doc(widget.idclass)
        .collection('addchildren')
        .doc()
        .id;

    // Kiểm tra các trường đầu vào
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      // Lưu thông tin học sinh lên Firestore
      await _firestore
          .collection('addclass')
          .doc(widget.idclass)
          .collection('addchildren')
          .doc(id)
          .set({
        'timestamp': DateTime.now(),
        'email': loggedInUser.email,
        'code': code,
        'fnchildren': fNChildren,
        'yobchildren': yOBchildren,
        'pobchildren': pOBchildren,
        'address': address,
        'namem': nameM,
        'namef': nameF,
        'emailparent': emailParent,
        'sdt': sdt,
        'imagec': imageUrlC,
        'imagef': imageUrlF,
        'imagem': imageUrlM,
        'id': id,
        'gt': gt,
        'quantity': quantity,
      });

      // Hiển thị thông báo thành công
      EasyLoading.showSuccess('Add Successful!');

      // Hiển thị mã QR
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QRCodeWidget(
                id: id,
                idclass: widget.idclass,
              )));
    } else {
      // Hiển thị thông báo lỗi
      EasyLoading.showError('Can\'t Add Product!');
    }
  }

  uploadImageC() async {
    final imagePickerC = ImagePicker();
    PickedFile? imageC;
    // ignore: unused_local_variable
    UploadTask uploadTaskC;
    await Permission.photos.request();
    // ignore: unused_local_variable
    var permissionStatusC = await Permission.photos.status;
    // ignore: deprecated_member_use
    imageC = await imagePickerC.getImage(source: ImageSource.gallery);
    var fileC = File(imageC!.path);
    // ignore: unnecessary_null_comparison
    if (imageC != null) {
      var snapshotC = await FirebaseStorage.instance
          .ref()
          .child('img/${imageC.path.split('/').last}')
          .putFile(fileC)
          // ignore: avoid_print
          .whenComplete(() => print('success'));
      var downloadUrlC = await snapshotC.ref.getDownloadURL();
      setState(() {
        imageUrlC = downloadUrlC;
      });
    } else {
      // ignore: avoid_print
      print('No image path received');
    }
  }

  uploadImageF() async {
    final imagePickerF = ImagePicker();
    PickedFile? imageF;
    // ignore: unused_local_variable
    UploadTask uploadTaskF;
    await Permission.photos.request();
    // ignore: unused_local_variable
    var permissionStatusF = await Permission.photos.status;
    // ignore: deprecated_member_use
    imageF = await imagePickerF.getImage(source: ImageSource.gallery);
    var fileF = File(imageF!.path);
    // ignore: unnecessary_null_comparison
    if (imageF != null) {
      var snapshotF = await FirebaseStorage.instance
          .ref()
          .child('img/${imageF.path.split('/').last}')
          .putFile(fileF)
          // ignore: avoid_print
          .whenComplete(() => print('success'));
      var downloadUrlF = await snapshotF.ref.getDownloadURL();
      setState(() {
        imageUrlF = downloadUrlF;
      });
    } else {
      // ignore: avoid_print
      print('No image path received');
    }
  }

  uploadImageM() async {
    final imagePickerM = ImagePicker();
    PickedFile? imageM;
    // ignore: unused_local_variable
    UploadTask uploadTaskM;
    await Permission.photos.request();
    // ignore: unused_local_variable
    var permissionStatusM = await Permission.photos.status;
    // ignore: deprecated_member_use
    imageM = await imagePickerM.getImage(source: ImageSource.gallery);
    var fileM = File(imageM!.path);
    // ignore: unnecessary_null_comparison
    if (imageM != null) {
      var snapshotM = await FirebaseStorage.instance
          .ref()
          .child('img/${imageM.path.split('/').last}')
          .putFile(fileM)
          // ignore: avoid_print
          .whenComplete(() => print('success'));
      var downloadUrlM = await snapshotM.ref.getDownloadURL();
      setState(() {
        imageUrlM = downloadUrlM;
      });
    } else {
      // ignore: avoid_print
      print('No image path received');
    }
  }
}
