import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  final String id;
  const QRScannerScreen({Key? key, required this.id}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String _result = '';

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        _result = scanData.code!;
      });

      final querySnapshot = await FirebaseFirestore.instance
          .collection('addclass')
          .doc(widget.id)
          .collection('addchildren')
          .doc(_result)
          .get();

      if (querySnapshot.exists) {
        final data = querySnapshot.data()!;
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChildDetailsPage(data: data)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        title: const Text(
          'QR Scanner',
          style: TextStyle(fontFamily: 'NotoSerif', fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(_result),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ChildDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChildDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 151, 144),
        title: const Text(
          'Thông tin',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(data['imagec']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Thông tin của trẻ',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSerif',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 151, 144),
                ),
              ),
              Text(
                'Mã số: ${data['code']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Họ và tên: ${data['fnchildren']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Giới tính: ${data['gt']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Năm sinh: ${data['yobchildren']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Nơi sinh: ${data['pobchildren']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const Text(
                'Thông tin của phụ huynh',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSerif',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 151, 144),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(data['imagef']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Họ và tên cha: ${data['namef']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(data['imagem']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Họ và tên mẹ: ${data['namem']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Email: ${data['emailparent']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Số điện thoại: ${data['sdt']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Địa chỉ: ${data['address']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
