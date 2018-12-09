import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/utils/themes.dart';
import 'package:passless_android/receipt_app.dart';

// TODO: Remove the slowing of animations.
import 'package:flutter/scheduler.dart' show timeDilation;

/// Main entry point for the app.
void main() {
  timeDilation = 4.0;
  runApp(ReceiptMaterialApp());
}

/// Root class for the material app.
class ReceiptMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceiptMaterialAppState();
}

/// Defines material app state like the theme.
class _ReceiptMaterialAppState extends State<ReceiptMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return DataProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        theme: ThemeData.light(), 
        home: ReceiptApp(),
      )
    );
  }
}
