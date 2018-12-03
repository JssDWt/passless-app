import 'package:flutter/material.dart';
import 'package:passless_android/data/database.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.note), 
            tooltip: "Notes",
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.delete), 
            tooltip: "Delete",
            onPressed: () async {
              await new Repository().delete(_receipt);

              // TODO: The content of the parent list is currently not refreshed
              Navigator.of(context).pop();
            },),
        ],
      ),
      body: new ReceiptDetailView(_receipt),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
          ],
        ),
    )
    );
  }
}