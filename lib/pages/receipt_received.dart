import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_detailview.dart';

/// A page that shows receipt details.
class ReceiptReceivedPage extends StatefulWidget {
  final Receipt _receipt;

  ReceiptReceivedPage(this._receipt);

  @override
  _ReceiptReceivedState createState() => new _ReceiptReceivedState();
}

/// The state of a single receipt page.
class _ReceiptReceivedState extends State<ReceiptReceivedPage> {
  Receipt receipt;

  @override
  initState() {
    super.initState();
    initReceipt();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Set the receipt state when it is initialized.
  initReceipt() async {
    setState(() {
      receipt = widget._receipt;
    });
  }

  /// Build the receipt view.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("New Receipt"),
        centerTitle: true,
      ),
      body: new ReceiptDetailView(receipt)
    );
  }
}