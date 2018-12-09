import 'package:flutter/material.dart';
import 'package:passless_android/widgets/drawer_menu.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Hero(
            tag: "appBarLeading",
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                icon: Icon(Icons.menu),
                tooltip: 'Navigation menu',
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              )
            )
          )
        ),
        title: Text("Settings"),
        actions: <Widget>[
          IconButton(
            icon: Hero(
              tag: "searchIcon",
              child: Material(
                type: MaterialType.transparency,
                child: Icon(Icons.search)
              )
            ),
            tooltip: 'Search settings',
            onPressed: null
          )
        ]
      ),
      body: Row(
        children: <Widget>[
          Text("No Settings here yet...")
        ],
      )
    );
  }

}