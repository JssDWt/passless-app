import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/root_page.dart';
import 'package:nfc/nfc.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/receipt_detail_page.dart';

/// Root application part.
class ReceiptApp extends StatefulWidget {
  @override
  _ReceiptAppState createState() => new _ReceiptAppState();
}

/// Root application state. Initializes the receipt data.
class _ReceiptAppState extends State<ReceiptApp> {
  final Nfc _nfc = Nfc();
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// Initializes the nfc plugin.
  initPlatformState() async {
    _nfc.configure(
      onMessage: (String message) async {
        await _onMessage(message);
      }
    );
  }

  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    return new RootPage();
  }

  /// Handles received ndef messages (receipts)
  Future<void> _onMessage(String message) async {
    var receiptJson = json.decode(message);
    Receipt receipt = Receipt.fromJson(receiptJson);
    await Repository.of(context).saveReceipt(receipt);
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => new ReceiptDetailPage(receipt, "New Receipt")
      )
    );
  }
}
