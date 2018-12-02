import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'data/database.dart';
import 'models/receipt.dart';
import 'widgets/receipt_inherited.dart';
import 'pages/root_page.dart';
import 'package:nfc/nfc.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/receipt_received.dart';

/// Root application part.
class ReceiptApp extends StatefulWidget {
  @override
  _ReceiptAppState createState() => new _ReceiptAppState();
}

/// Root application state. Initializes the receipt data.
class _ReceiptAppState extends State<ReceiptApp> {
  final Nfc _nfc = Nfc();
  List<Receipt> receipts;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// Initializes the receipts.
  initPlatformState() async {
    _isLoading = true;

    _nfc.configure(
      onMessage: (String message) async {
        await _showMessage(message);
      }
    );

    var lreceipts;
    try {
      lreceipts = await new Repository().getReceipts();
    } catch (e) {
      print("Failed to get receipts: '${e.message}'.");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// Sets the receipts as state and stops the loading process.
    setState(() {
      receipts = lreceipts;
      _isLoading = false;
    });
  }

  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    return new ReceiptInheritedWidget(receipts, _isLoading, new RootPage());
  }

  Future<void> _showMessage(String message) async {
    var receiptJson = json.decode(message);
    Receipt receipt = Receipt.fromJson(receiptJson);

    await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ReceiptReceivedPage(receipt)
      )
    );
  }
}
