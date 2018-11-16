import 'package:flutter/material.dart';
import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/widgets/receipt_listview.dart';
import 'package:passless_android/pages/search_page.dart';

/// The root page of the app.
class RootPage extends StatelessWidget {

  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    // Fetch the loading boolean.
    final rootIW = ReceiptInheritedWidget.of(context);

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
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SearchPage())
              );
            },
          ),
        ],
      ),
      // Either load or show the list of receipts.
      body: rootIW.isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new Scrollbar(child: new ReceiptListView()),
    );
  }
}
