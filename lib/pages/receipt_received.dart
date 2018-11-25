import 'package:flutter/material.dart';

class ReceiptReceivedPage extends StatelessWidget {
  final String receiptJson;
  ReceiptReceivedPage(this.receiptJson);
  @override
  Widget build(BuildContext context) {
    return new Text(receiptJson);
  }

}