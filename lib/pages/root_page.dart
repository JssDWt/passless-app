import 'package:flutter/material.dart';
import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/widgets/receipt_listview.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootIW = ReceiptInheritedWidget.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Passless receipts"),
      ),
      body: rootIW.isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new Scrollbar(child: new ReceiptListView()),
    );
  }
}
