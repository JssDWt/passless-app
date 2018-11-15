import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

/// A page that shows receipt details.
class ReceiptDetail extends StatefulWidget {
  final Receipt _receipt;

  ReceiptDetail(this._receipt);

  @override
  _ReceiptDetailState createState() => new _ReceiptDetailState();
}

/// 
class _ReceiptDetailState extends State<ReceiptDetail> {
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

  initReceipt() async {
    setState(() {
          receipt = widget._receipt;
        });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(receipt.vendor.name),
        centerTitle: true,
      ),
      body: new Container(
        color: Theme.of(context).backgroundColor,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Text("Price: ${receipt.total}")
          ],
        ),
      ),
);
  }
}