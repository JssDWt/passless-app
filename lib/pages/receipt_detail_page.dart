import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/comment_page.dart';
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
    return Hero(
      tag: "receipt${widget._receipt.id}",
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.note), 
              tooltip: "Notes",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentPage(widget._receipt)
                  )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete), 
              tooltip: "Delete",
              onPressed: () async {
                bool shouldDelete = await showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text("Delete receipt?"),
                    content: const Text("You will not be able to recover the receipt later."),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text("CANCEL"),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(false);
                        },
                      ),
                      FlatButton(
                        child: const Text("DELETE"),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(true);
                        },
                      ),
                    ],
                  )
                );

                if (shouldDelete) {
                  await Repository.of(context).delete(widget._receipt);
                  Navigator.of(context).pop();
                }
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
      )
    );
  }
}