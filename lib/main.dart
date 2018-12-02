
import 'package:flutter/material.dart';
import 'utils/themes.dart';
import 'receipt_app.dart';

/// Main entry point for the app.
void main() => runApp(new ReceiptMaterialApp());

/// Root class for the material app.
class ReceiptMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReceiptMaterialAppState();
  }
}

/// Defines material app state like the theme.
class ReceiptMaterialAppState extends State<ReceiptMaterialApp> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, 
        theme: darkTheme, 
        home: new ReceiptApp());
  }
}
