import 'package:flutter/material.dart';
import 'package:passless_android/data/database.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/receipt_listview.dart';
import 'package:rxdart/subjects.dart';

class SearchProvider extends InheritedWidget {
  SearchProvider({
    Key key,
    @required this.searchBloc,
    @required Widget child,
  })  : assert(
            searchBloc != null, "searchBloc of SearchProvider cannot be null."),
        assert(child != null, "child of SearchProvider cannot be null."),
        super(key: key, child: child);

  final SearchBloc searchBloc;
  
  static SearchProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SearchProvider);
  }

  @override
  bool updateShouldNotify(SearchProvider oldWidget) {
    return this.searchBloc != oldWidget.searchBloc;
  }
}

class SearchBloc {
  final _repo = Repository();
  Sink<String> get search => _searchSubject.sink;
  final _searchSubject = BehaviorSubject<String>();
  Stream<List<Receipt>> get receipts => _receiptSubject.stream;
  final _receiptSubject = BehaviorSubject<List<Receipt>>();

  SearchBloc() {
    _searchSubject.stream.debounce(Duration(microseconds: 400)).listen(
      (s) {
        if (s != null) {
          _repo.search(s).then((result) => _receiptSubject.add(result));
        }
      }
    );
  }

  Future close() async  {
    await _searchSubject.close();
    await _receiptSubject.close();
    await _repo.close();
  }
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = SearchProvider.of(context).searchBloc;
    // Build the page.
    return new Scaffold(
        appBar: new AppBar(
          title: new TextField(
              autofocus: true,
              onChanged: (s) => searchBloc.search.add(s),
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
