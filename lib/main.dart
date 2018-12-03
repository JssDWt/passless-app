import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/utils/themes.dart';
import 'package:passless_android/receipt_app.dart';

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
  Widget build(BuildContext context) {
    return new DataProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        theme: darkTheme, 
        home: ReceiptApp(),
      )
    );
  }
}
