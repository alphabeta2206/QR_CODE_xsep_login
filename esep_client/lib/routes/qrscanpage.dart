import 'package:flutter/material.dart';
import '../partials/custom_textfield.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_qr_bar_scanner/flutter_qr_bar_scanner.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}
class _ScanState extends State<Scan> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      toolbarHeight: 90.0,
      title: Text(
        "Scan QR Code",
        style: const TextStyle(
          fontSize: 28.0,
          color: Colors.blueGrey,
        ),
      ),
    ));
  }
}
