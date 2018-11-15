import 'package:flutter/material.dart';
import 'data/database.dart';
import 'models/receipt.dart';
import 'widgets/receipt_inherited.dart';
import 'pages/root_page.dart';

/// Root application part.
class ReceiptApp extends StatefulWidget {
  @override
  _ReceiptAppState createState() => new _ReceiptAppState();
}

/// Root application state. Initializes the receipt data.
class _ReceiptAppState extends State<ReceiptApp> {
  List<Receipt> receipts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    _isLoading = true;

    var lreceipts;
    try {
      lreceipts = await new Repository().getReceipts();
    } catch (e) {
      print("Failed to get receipts: '${e.message}'.");
    }

    print(lreceipts);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      receipts = lreceipts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ReceiptInheritedWidget(receipts, _isLoading, new RootPage());
  }
}
