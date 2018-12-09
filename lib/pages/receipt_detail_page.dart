import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_detail_view.dart';

/// A page that shows receipt details.
class ReceiptDetailPage extends StatefulWidget {
  final Receipt _receipt;
  final String _title;
  ReceiptDetailPage(this._receipt, this._title);

  @override
  State<StatefulWidget> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends State<ReceiptDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
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
              // TODO: Move deletion to a BLOC?
              await Repository.of(context).delete(widget._receipt);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ReceiptDetailView(widget._receipt),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
          ],
        ),
    )
    );
  }
}