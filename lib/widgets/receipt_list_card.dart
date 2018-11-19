
import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/receipt_detail.dart';

class ReceiptListCard extends StatelessWidget {
  final Receipt receipt;
  
  ReceiptListCard(this.receipt);

  @override
  Widget build(BuildContext context) {
    // Build a single receipt tile.
        return new ListTile(
          dense: false,
          title: new Text(receipt.vendor.name),
          subtitle: new Text(
            "${receipt.currency} ${receipt.total}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            // On tap go to the receipt detail page.
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ReceiptDetail(receipt)));
          },
        );
  }

}