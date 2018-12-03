import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/receipt_detail_page.dart';

class ReceiptListCard extends StatelessWidget {
  final Receipt receipt;

  ReceiptListCard(this.receipt);

  @override
  Widget build(BuildContext context) {
    // Build a single receipt tile.
    return new Card(
      child: ListTile(
        title: new Text(receipt.vendor.name),
        subtitle: new Text(
          "${receipt.currency} ${receipt.total}",
          style: Theme.of(context).textTheme.caption,
        ),
        onTap: () async {
          // On tap go to the receipt detail page.
          await Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => 
                new ReceiptDetailPage(receipt, receipt.vendor.name)));
        }
      )
    );
  }
}
