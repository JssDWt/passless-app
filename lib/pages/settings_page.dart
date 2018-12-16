import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc/nfc.dart';
import 'package:passless_android/data/nfc_provider.dart';
import 'package:passless_android/widgets/drawer_menu.dart';
import 'package:passless_android/widgets/menu_button.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Nfc _nfc;
  StreamSubscription<bool> _nfcStateChange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nfc == null) {
      _nfc = NfcProvider.of(context); 
    }
    
    if (_nfcStateChange == null) {
      _nfcStateChange = _nfc.nfcStateChange.listen((newValue) {
        setState((){});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_nfcStateChange != null) {
      _nfcStateChange.cancel();
      _nfcStateChange = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => MenuButton()
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("NFC"),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.nfc),
                    title: Text(
                      "NFC is ${_nfc.nfcEnabled ? "enabled" : "disabled"}."
                    ),
                    trailing: _nfc.nfcEnabled ? null : FlatButton(
                      child: Text("ENABLE"),
                      onPressed: () {
                        _nfc.gotoNfcSettings();
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Data"),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.sync),
                    title: Text("Cloud backup"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      // TODO: Go to cloud backup settings.
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Localization"),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("Language"),
                    trailing: Text("English"),
                    onTap: () {
                      // TODO: show language picker and change language.
                    },
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }

}