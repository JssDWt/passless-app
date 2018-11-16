import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build the page.
    return new Scaffold(
      appBar: new AppBar(
        title: new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          )
        ),
      ),
      // body: rootIW.isLoading
      //     ? new Center(child: new CircularProgressIndicator())
      //     : new Scrollbar(child: new ReceiptListView()),
    );
  }

}