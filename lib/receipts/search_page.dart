import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/receipts/receipt_listview.dart';
import 'package:passless/widgets/spinning_hero.dart';
import 'package:rxdart/subjects.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchSubject = BehaviorSubject<String>();
  final TextEditingController _controller = TextEditingController();
  String currentSearch = "";

  @override 
  void initState() {
    super.initState();
    _searchSubject.stream
      .debounce(Duration(milliseconds: 400))
      .listen((s) {
        if (!mounted) return;
        setState(() {
          currentSearch = s;
        });
      });
  }

  @override
  void dispose() {
    _searchSubject.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var matLoc = MaterialLocalizations.of(context);
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
                tooltip: matLoc.backButtonTooltip,
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
            _searchSubject.sink.add(s);
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
            hintText: matLoc.searchFieldLabel,
            suffixIcon: IconTheme(
              data: Theme.of(context).primaryIconTheme,
              child: IconButton(
                icon: Icon(Icons.clear),
                tooltip: loc.clearTooltip,
                onPressed: () {
                  _controller.clear();
                  _searchSubject.sink.add("");
                },
              ),
            )
          )
        ),
      ),
      body: ReceiptListView(
        dataFunction: (offset, length) 
          => Repository.of(context).search(currentSearch, offset, length),
      )
    );
  }
}
