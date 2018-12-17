import 'package:flutter/material.dart';
import 'package:passless_android/pages/latest_receipts_page.dart';
import 'package:passless_android/pages/search_page.dart';
import 'package:passless_android/pages/settings_page.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Latest receipts"),
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
            title: Text("Search"),
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
            title: Text('Settings'),
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