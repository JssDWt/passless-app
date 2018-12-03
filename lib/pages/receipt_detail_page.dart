import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_detail_view.dart';

/// A page that shows receipt details.
class ReceiptDetailPage extends StatelessWidget {
  final Receipt _receipt;
  final String _title;
  ReceiptDetailPage(this._receipt, this._title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
        centerTitle: true,
      ),
      body: new ReceiptDetailView(_receipt)
    );
  }
}