import 'package:flutter/material.dart';
import 'package:nfc/nfc.dart';
import 'package:nfc/nfc_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/settings/backup_page.dart';
import 'package:passless/utils/radio_dialog.dart';
import 'package:passless/widgets/appbar_button.dart';
import 'package:passless/widgets/drawer_menu.dart';
import 'package:passless/widgets/menu_button.dart';
import 'package:passless/settings/preferences_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var matLoc = MaterialLocalizations.of(context);
    var preferencesProvider = PreferencesProvider.of(context);

    Nfc nfc = NfcProvider.of(context);
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: MenuButton(),
        title: Text(loc.settings),
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
            tooltip: matLoc.searchFieldLabel,
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
              child: Text(loc.nfc),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.nfc),
                    title: Text(
                      nfc.nfcEnabled ? loc.nfcEnabled : loc.nfcDisabled
                    ),
                    trailing: nfc.nfcEnabled ? null : FlatButton(
                      child: Text(loc.enable),
                      onPressed: () {
                        nfc.gotoNfcSettings();
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(loc.data),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.cloud_upload),
                    title: Text(loc.cloudBackup),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BackupPage()
                        )
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(loc.preferences),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(loc.vatSettings),
                    subtitle: Text(
                      preferencesProvider.preferences.includeTax 
                        ? loc.includeTax : loc.excludeTax
                    ),
                    onTap: () async {
                      bool oldShouldInclude = 
                        preferencesProvider.preferences.includeTax;
                      bool shouldInclude = await showDialog(
                        context: context, 
                        builder: (context) => RadioDialog(
                          initialValue: oldShouldInclude,
                          title: loc.vatSettings,
                          options: {
                            loc.includeTax: true,
                            loc.excludeTax: false
                          }
                        )
                      );

                      if (oldShouldInclude != shouldInclude) {
                        var newPreferences = preferencesProvider.preferences;
                        newPreferences.includeTax = shouldInclude;
                        preferencesProvider.updatePreferences(newPreferences);
                        setState(() {});
                      }
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