import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/receipts/latest_receipts_page.dart';
import 'package:passless/receipts/receipt_detail_page.dart';
import 'package:passless/data/invalid_receipt_exception.dart';
import 'package:nfc/nfc.dart';


/// Root application part.
class ReceiptApp extends StatefulWidget {
  @override
  _ReceiptAppState createState() => _ReceiptAppState();
}

/// Root application state. Initializes the receipt data.
class _ReceiptAppState extends State<ReceiptApp> {
  final Nfc _nfc = Nfc();

  @override
  void initState() {
    super.initState();
    _nfc.configure(
      onMessage: _onMessage
    ).then((r) {
      if (!mounted) return;
      setState((){});
    });
  }
  
  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    return LatestReceiptsPage();
  }

  /// Handles received ndef messages (receipts)
  Future<void> _onMessage(String message) async {
    Receipt receipt;
    try
    {
      receipt = await Repository().saveReceipt(message);
    }
    on InvalidReceiptException catch (e)
    {
      // TODO: Notify issuer receipt is not valid.
      debugPrint("Failed to deserialize receipt:\n$e");
    }

    if (receipt == null || !mounted) return;

    // TODO: Verify receipt integrity
    // TODO: Verify receipt contents
    // TODO: Persist the validation stages.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReceiptDetailPage(receipt)
      )
    );
  }
}
