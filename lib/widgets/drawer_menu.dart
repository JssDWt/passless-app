import 'package:flutter/material.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/receipts/latest_receipts_page.dart';
import 'package:passless_android/receipts/search_page.dart';
import 'package:passless_android/settings/settings_page.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var matLoc = MaterialLocalizations.of(context);
    var loc = PasslessLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: matLoc.backButtonTooltip,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text(loc.latestReceiptsTitle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LatestReceiptsPage())
              );
            }
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(matLoc.searchFieldLabel),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage())
              );
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(loc.settings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage()
                )
              );
            },
          ),
        ],
      )
    );
  }

}