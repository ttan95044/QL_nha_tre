import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlnhatre/screens/add_class/add_sub/add_children_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';

class QRCodeWidget extends StatefulWidget {
  final String idclass;
  final String id;

  const QRCodeWidget({super.key, required this.id, required this.idclass});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  late String _qrData;
  bool _isLoading = false;
  Uint8List? _imageData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Uint8List> _generateQRCodeImageData(String data) async {
    final qrImageData = await QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImageData(400);

    return qrImageData!.buffer.asUint8List();
  }

  Future<void> _saveQRCodeImage() async {
    setState(() {
      _isLoading = true;
    });

    final Uint8List qrImageData = await _generateQRCodeImageData(_qrData);
    final img.Image qrImage = img.decodeImage(qrImageData)!;

    final Reference storageRef =
        _storage.ref().child('qrcodes/${widget.id}.jpg');

    final Uint8List imageData =
        Uint8List.fromList(img.encodeJpg(qrImage, quality: 100));
    final UploadTask uploadTask = storageRef.putData(imageData);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.success) {
        storageRef.getDownloadURL().then((imageUrl) {
          _saveDataToFirestore(imageUrl);
        });
      }
    });
  }

  Future<void> _saveDataToFirestore(String imageUrlQR) async {
    await _firestore
        .collection('addclass')
        .doc(widget.idclass)
        .collection('addchildren')
        .doc(widget.id)
        .update({'imageUrlQR': imageUrlQR});
    setState(() {
      _isLoading = false;
      _imageData = null;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChildrenScreen(
          idclass: widget.idclass,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _qrData = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        title: const Text('QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _imageData != null
                  ? Image.memory(_imageData!)
                  : FutureBuilder<Uint8List>(
                      future: _generateQRCodeImageData(_qrData),
                      builder: (BuildContext context,
                          AsyncSnapshot<Uint8List> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          _imageData = snapshot.data;
                          return Image.memory(_imageData!);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        onPressed: _saveQRCodeImage,
        child: const Icon(Icons.save),
      ),
    );
  }
}
