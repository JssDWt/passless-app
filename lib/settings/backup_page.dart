import 'package:flutter/material.dart';
import 'package:passless/data/backup_connection_pref.dart';
import 'package:passless/data/backup_interval.dart';
import 'package:passless/data/preferences.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/utils/radio_dialog.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  

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
                FutureBuilder(
                  future: Preferences.getLastLocalBackup(),
                  builder: (context, snapshot) {
                    String dateString = "";
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        dateString = loc.datetime(snapshot.data);
                      } else {
                        dateString = loc.never;
                      }
                    }

                    return Text("${loc.local}: $dateString", style: subTextStyle);
                  }
                ),
                FutureBuilder(
                  future: Preferences.getLastCloudBackup(),
                  builder: (context, snapshot) {
                    String dateString = "";
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        dateString = loc.datetime(snapshot.data);
                      } else {
                        dateString = loc.never;
                      }
                    }
                    return Text("${loc.googleDrive}: $dateString", style: subTextStyle);
                  }
                ),
                FutureBuilder(
                  future: Preferences.getLastBackupSize(),
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
                  subtitle: FutureBuilder(
                    future: Preferences.getCloudBackupInterval(),
                    builder: (context, snapshot) {
                      String text;
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case BackupInterval.never:
                            text = loc.neverOption;
                            break;
                          case BackupInterval.onClick:
                            text = loc.onlyOnClickOption;
                            break;
                          case BackupInterval.daily:
                            text = loc.dailyOption;
                            break;
                          case BackupInterval.weekly:
                            text = loc.weeklyOption;
                            break;
                          case BackupInterval.monthly:
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
                    var currentInterval = await Preferences.getCloudBackupInterval();
                    BackupInterval newInterval = await showDialog(
                      context: context,
                      builder: (context) => RadioDialog(
                        options: {
                          loc.neverOption: BackupInterval.never,
                          loc.onlyOnClickOption: BackupInterval.onClick,
                          loc.dailyOption: BackupInterval.daily,
                          loc.weeklyOption: BackupInterval.weekly,
                          loc.monthlyOption: BackupInterval.monthly
                        },
                        initialValue: currentInterval,
                        title: loc.backupToGoogleDrive,
                      )
                    );
                    
                    await Preferences.setCloudBackupInterval(newInterval);
                    if (!mounted) return;
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text(loc.account),
                  subtitle: FutureBuilder(
                    future: Preferences.getCloudBackupAccount(),
                    builder: (context, snapshot) => Text(snapshot.data ?? loc.selectAccount)
                  ),
                  contentPadding: EdgeInsets.all(0),
                  onTap: null // TODO: Implement account picker.
                ),
                ListTile(
                  title: Text(loc.createBackupVia),
                  subtitle: FutureBuilder(
                    future: Preferences.getBackupConnectionPref(),
                    builder: (context, snapshot) {
                      String text = loc.wifiOnly;
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case BackupConnectionPref.wifiOnly:
                            text = loc.wifiOnly;
                            break;
                          case BackupConnectionPref.wifiOrMobileNetwork:
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
                    var currentPref = await Preferences.getBackupConnectionPref();
                    BackupConnectionPref newPref = await showDialog(
                      context: context,
                      builder: (context) => RadioDialog(
                        options: {
                          loc.wifiOnly: BackupConnectionPref.wifiOnly,
                          loc.wifiOrMobileNetwork: BackupConnectionPref.wifiOrMobileNetwork
                        },
                        initialValue: currentPref,
                        title: loc.createBackupVia,
                      )
                    );
                    
                    await Preferences.setBackupConnectionPref(newPref);
                    if (!mounted) return;
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