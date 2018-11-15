import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/pages/receipt_detail.dart';

class ReceiptListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootIW = ReceiptInheritedWidget.of(context);
    List<Receipt> receipts = rootIW.receipts;
    return new ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, int index) {
        var receipt = receipts[index];

        return new ListTile(
          dense: false,
          title: new Text(receipt.vendor.name),
          subtitle: new Text(
            "${receipt.currency} ${receipt.total}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ReceiptDetail(receipt)));
          },
        );
      },
    );
  }
}