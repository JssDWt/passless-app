import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/pages/receipt_detail.dart';

/// Shows a list of receipts.
class ReceiptListView extends StatelessWidget {

  /// Builds the receipt list.
  @override
  Widget build(BuildContext context) {

    // Fetch the receipts from the context.
    final rootIW = ReceiptInheritedWidget.of(context);
    List<Receipt> receipts = rootIW.receipts;

    // Build the view.
    return new ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, int index) {
        Receipt receipt = receipts[index];

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
      },
    );
  }
}