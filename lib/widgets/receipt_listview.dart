import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/widgets/receipt_list_card.dart';

/// Shows a list of receipts.
class ReceiptListView extends StatelessWidget {

  ReceiptListView(this.receipts);
  final List<Receipt> receipts;

  /// Builds the receipt list.
  @override
  Widget build(BuildContext context) {
    // If there are no receipts, don't build the list.
    if (!receipts.isNotEmpty) {
      return new Text("No receipts found.");
    }

    // Build the view.
    return new ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, int index) {
        Receipt receipt = receipts[index];
        return ReceiptListCard(receipt);
      },
    );
  }
}