import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_listview.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc {
  final Repository _repo;
  Sink<String> get search => _searchSubject.sink;
  final _searchSubject = BehaviorSubject<String>();
  Stream<List<Receipt>> get receipts => _receiptSubject.stream;
  final _receiptSubject = BehaviorSubject<List<Receipt>>();

  SearchBloc(this._repo) {
    print("searchBloc contructor");
    _searchSubject.stream
      .debounce(Duration(milliseconds: 400))
      .listen((s) => _handleSearch(s));

    _repo.listen(() {
      _handleSearch(_searchSubject.value);
    });
  }

  Future close() async  {
    await _searchSubject.close();
    await _receiptSubject.close();
  }

  Future _handleSearch(String s) async {
    print("SearchBloc is handling search for '$s'.");
    if (s != null) {
      var receipts = await _repo.search(s);
      _receiptSubject.add(receipts);
    }
  }
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  SearchBloc searchBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (searchBloc == null) {
      searchBloc = SearchBloc(Repository.of(context));
    }
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the page.
    return new Scaffold(
        appBar: new AppBar(
          title: new TextField(
              autofocus: true,
              onChanged: (s) {
                print("onChanged is adding '$s'");
                searchBloc.search.add(s);
              },
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search), hintText: 'Search...')),
        ),
        body: StreamBuilder<List<Receipt>>(
            stream: searchBloc.receipts,
            initialData: new List<Receipt>(),
            builder: (context, snapshot) =>
                new ReceiptListView(snapshot.data)));
  }
}
