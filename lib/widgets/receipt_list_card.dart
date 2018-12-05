import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/pages/receipt_detail_page.dart';

class ReceiptListCard extends StatelessWidget {
  final Receipt _receipt;

  ReceiptListCard(this._receipt);

  @override
  Widget build(BuildContext context) {
    // Build a single receipt tile.
    return Card(
      child: ListTile(
        title: Text(_receipt.vendor.name),
        subtitle: Text(
          "${_receipt.currency} ${_receipt.total}",
          style: Theme.of(context).textTheme.caption,
        ),
        onTap: () {
          // On tap go to the receipt detail page.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => 
                ReceiptDetailPage(_receipt, _receipt.vendor.name)));
        }
      )
    );
  }
}
