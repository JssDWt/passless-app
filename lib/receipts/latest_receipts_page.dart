import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/widgets/appbar_button.dart';
import 'package:passless/widgets/drawer_menu.dart';
import 'package:passless/widgets/menu_button.dart';
import 'package:passless/receipts/receipt_listview.dart';
import 'package:passless/receipts/search_page.dart';

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
          AppBarButton(
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
        dataFunction: Repository().getReceipts,
      ),
    );
  }
}