import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/widgets/drawer_menu.dart';
import 'package:passless_android/widgets/menu_button.dart';
import 'package:passless_android/receipts/receipt_listview.dart';
import 'package:passless_android/receipts/search_page.dart';

/// The root page of the app.
class LatestReceiptsPage extends StatelessWidget {
  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: MenuButton(),
        title: Text(PasslessLocalizations.of(context).latestReceiptsTitle),
        actions: <Widget>[
          IconButton(
            icon: Hero(
              tag: "searchIcon",
              child: Material(
                color: Colors.transparent,
                child: IconTheme(
                  data: Theme.of(context).primaryIconTheme,
                  child: Icon(Icons.search)
                )
              )
            ),
            tooltip: MaterialLocalizations.of(context).searchFieldLabel,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchPage())
              );
            }
          )
        ]
      ),
      // Either load or show the list of receipts.
      body: ReceiptListView(
        dataFunction: Repository.of(context).getReceipts,
      ),
    );
  }
}