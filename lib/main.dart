import 'package:flutter/material.dart';
import 'utils/themes.dart';
import 'receipt_app.dart';

void main() => runApp(new ReceiptMaterialApp());

class ReceiptMaterialApp extends StatefulWidget {
  @override
  ReceiptMaterialAppState createState() {
    return new ReceiptMaterialAppState();
  }
}

class ReceiptMaterialAppState extends State<ReceiptMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, 
        theme: darkTheme, 
        home: new ReceiptApp());
  }
}
