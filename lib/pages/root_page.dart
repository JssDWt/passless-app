import 'package:flutter/material.dart';
import 'package:passless_android/data/database.dart';
import 'package:passless_android/widgets/receipt_listview.dart';
import 'package:passless_android/pages/search_page.dart';
import 'package:passless_android/models/receipt.dart';

/// The root page of the app.
class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RootPageState();
}

class RootPageState extends State<RootPage> {
  List<Receipt> _receipts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initReceipts();
  }

  _initReceipts() async {
    var receipts;
    try {
      receipts = await new Repository().getReceipts();
    } catch (e) {
      print("Failed to get receipts: '${e.message}'.");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// Sets the receipts as state and stops the loading process.
    setState(() {
      _receipts = receipts;
      _isLoading = false;
    });
  }

  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    // Build the page.
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: new Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: new Text("Passless receipts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new SearchPage())
              );
            }
          )
        ]
      ),
      // Either load or show the list of receipts.
      body: _isLoading ? 
        const CircularProgressIndicator() : 
        ReceiptListView(_receipts),
    );
  }
}