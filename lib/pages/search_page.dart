import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_listview.dart';
import 'package:passless_android/widgets/spinning_hero.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc {
  final Repository _repository;
  Sink<String> get search => _searchSubject.sink;
  final _searchSubject = BehaviorSubject<String>();
  Stream<List<Receipt>> get receipts => _receiptSubject.stream;
  final _receiptSubject = BehaviorSubject<List<Receipt>>();

  SearchBloc(this._repository) {
    _searchSubject.stream
      .debounce(Duration(milliseconds: 400))
      .listen((s) => _handleSearch(s));

    _repository.listen(() {
      _handleSearch(_searchSubject.value);
    });
  }

  Future close() async  {
    await _searchSubject.close();
    await _receiptSubject.close();
  }

  Future _handleSearch(String s) async {
    if (s != null) {
      var receipts = await _repository.search(s);
      _receiptSubject.add(receipts);
    }
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc _searchBloc;
  TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_searchBloc == null) {
      _searchBloc = SearchBloc(Repository.of(context));
    }
  }

  @override
  void dispose() {
    _searchBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the page.
    return Scaffold(
      appBar: AppBar(
        leading: SpinningHero(
          tag: "appBarLeading",
          child: Material(
            color: Colors.transparent,
            child: IconTheme(
              data: Theme.of(context).primaryIconTheme,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ),
        ),
        title: TextField(
          style: Theme.of(context).primaryTextTheme
            .title.copyWith(fontWeight: FontWeight.normal),
          controller: _controller,
          autofocus: true,
          onChanged: (s) {
            _searchBloc.search.add(s);
          },
          decoration: InputDecoration(
            prefixIcon: Hero(
              tag: "searchIcon",
              child: Material(
                color: Colors.transparent,
                child: IconTheme(
                  data: Theme.of(context).primaryIconTheme,
                  child: Icon(Icons.search)
                )
              )
            ),
            hintText: 'Search...',
            suffixIcon: IconTheme(
              data: Theme.of(context).primaryIconTheme,
              child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _searchBloc.search.add("");
                },
              ),
            )
          )
        ),
      ),
      body: StreamBuilder<List<Receipt>>(
        stream: _searchBloc.receipts,
        initialData: List<Receipt>(),
        builder: (context, snapshot) =>
          ReceiptListView(snapshot.data)));
  }
}
