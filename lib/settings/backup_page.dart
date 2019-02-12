import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/utils/radio_dialog.dart';
import 'package:passless/utils/shared_preferences_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  static const String LAST_LOCAL_BACKUP = "lastLocalBackup";
  static const String LAST_CLOUD_BACKUP = "lastCloudBackup";
  static const String LAST_BACKUP_SIZE = "lastBackupSize";
  static const String CLOUD_BACKUP_INTERVAL = "cloudBackupInterval";
  static const String CLOUD_BACKUP_ACCOUNT = "cloudBackupAccount";
  static const String BACKUP_CONNECTION_PREF = "backupConnectionPref";

  Widget _mainRow(Widget icon, Widget body)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20),
            child: icon,
          ),
          Expanded(child: body)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var theme = Theme.of(context);
    var subTextStyle = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.cloudBackup),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _mainRow(
            Icon(Icons.cloud_upload), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(loc.lastBackupTitle, style: theme.textTheme.subhead,),
                SharedPreferencesBuilder(
                  pref: LAST_LOCAL_BACKUP,
                  builder: (context, snapshot) {
                    String dateString = "";
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        DateTime date = DateTime.parse(snapshot.data);
                        dateString = loc.datetime(date);
                      } else {
                        dateString = loc.never;
                      }
                    }
                    return Text("${loc.local}: $dateString", style: subTextStyle);
                  }
                ),
                SharedPreferencesBuilder<String>(
                  pref: LAST_CLOUD_BACKUP,
                  builder: (context, snapshot) {
                    String dateString = "";
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        DateTime date = DateTime.parse(snapshot.data);
                        dateString = loc.datetime(date);
                      } else {
                        dateString = loc.never;
                      }
                    }
                    return Text("${loc.googleDrive}: $dateString", style: subTextStyle);
                  }
                ),
                SharedPreferencesBuilder<int>(
                  pref: LAST_BACKUP_SIZE,
                  builder: (context, snapshot) =>
                    Text("${loc.size}: ${loc.bytes(snapshot.data ?? 0)}", style: subTextStyle)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(loc.backupInfo),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: RaisedButton(
                    child: Text(loc.createBackupButtonLabel),
                    onPressed: null,
                  ),
                )
              ],
            )
          ),
          _mainRow(
            ImageIcon(AssetImage("assets/google-drive.png")), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(loc.googleDriveSettings, style: theme.textTheme.subhead,),
                ListTile(
                  title: Text(loc.backupToGoogleDrive),
                  subtitle: SharedPreferencesBuilder<String>(
                    pref: CLOUD_BACKUP_INTERVAL,
                    builder: (context, snapshot) {
                      String text;
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case "never":
                            text = loc.neverOption;
                            break;
                          case "onClick":
                            text = loc.onlyOnClickOption;
                            break;
                          case "daily":
                            text = loc.dailyOption;
                            break;
                          case "weekly":
                            text = loc.weeklyOption;
                            break;
                          case "monthly":
                            text = loc.monthlyOption;
                            break;
                          default:
                        }
                      } else {
                        text = loc.neverOption;
                      }
                      return Text(text);
                    },
                  ),
                  contentPadding: EdgeInsets.all(0),
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    String interval = await showDialog(
                      context: context,
                      builder: (context) => RadioDialog(
                        options: {
                          loc.neverOption: "never",
                          loc.onlyOnClickOption: "onClick",
                          loc.dailyOption: "daily",
                          loc.weeklyOption: "weekly",
                          loc.monthlyOption: "monthly"
                        },
                        initialValue: prefs.getString(CLOUD_BACKUP_INTERVAL) ?? "never",
                        title: loc.backupToGoogleDrive,
                      )
                    );
                    
                    await prefs.setString(CLOUD_BACKUP_INTERVAL, interval);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text(loc.account),
                  subtitle: SharedPreferencesBuilder<String>(
                    pref: CLOUD_BACKUP_ACCOUNT,
                    builder: (context, snapshot) => Text(snapshot.data ?? loc.selectAccount)
                  ),
                  contentPadding: EdgeInsets.all(0),
                  onTap: null // TODO: Implement account picker.
                ),
                ListTile(
                  title: Text(loc.createBackupVia),
                  subtitle: SharedPreferencesBuilder<String>(
                    pref: BACKUP_CONNECTION_PREF,
                    builder: (context, snapshot) {
                      String text = loc.wifiOnly;
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case "wifi":
                            text = loc.wifiOnly;
                            break;
                          case "both":
                            text = loc.wifiOrMobileNetwork;
                            break;
                          default:
                        }
                      }
                      
                      return Text(text);
                    }
                  ),
                  contentPadding: EdgeInsets.all(0),
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    String via = await showDialog(
                      context: context,
                      builder: (context) => RadioDialog(
                        options: {
                          loc.wifiOnly: "wifi",
                          loc.wifiOrMobileNetwork: "both"
                        },
                        initialValue: prefs.getString(BACKUP_CONNECTION_PREF) ?? "wifi",
                        title: loc.createBackupVia,
                      )
                    );
                    
                    await prefs.setString(BACKUP_CONNECTION_PREF, via);
                    setState(() {});
                  },
                )
              ],
            )
          )
        ],
      ),
    );
  }
}