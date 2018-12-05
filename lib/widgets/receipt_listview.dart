import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/widgets/receipt_list_card.dart';

/// Shows a list of receipts.
class ReceiptListView extends StatelessWidget {
  final List<Receipt> _receipts;
  ReceiptListView(this._receipts);

  /// Builds the receipt list.
  @override
  Widget build(BuildContext context) {
    // If there are no receipts, don't build the list.
    Widget result;
    if (_receipts.isNotEmpty) {
      // Build the view.
      result = ListView.builder(
        itemCount: _receipts.length,
        itemBuilder: (context, int index) => ReceiptListCard(_receipts[index]),
      );
    }
    else {
      result = Text("No receipts found.");
    }

    return result;
  }
}