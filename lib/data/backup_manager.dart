import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:passless/data/backup_connection_pref.dart';
import 'package:passless/data/backup_interval.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/data/data_exception.dart';
import 'package:passless/data/preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';

class BackupManager {
  static final Duration localBackupInterval = Duration(hours: 12);

  static const int _receiptsPerBatch = 50;

  static Future<String> get _backupPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/local_backup.json";
    return path;
  }

  static Future<String> get _tempBackupPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/local_temp_backup.json";
    return path;
  }

  static void initializeHeadless() {
    BackgroundFetch.registerHeadlessTask(_runBackupProcedure);
  }

  static Future _runBackupProcedure() async {
    debugPrint('[BackgroundFetch] Event received');
      int status = BackgroundFetch.FETCH_RESULT_NO_DATA;

      try {
        status = await _backupCheck();
      }
      on DataException catch(e) {
        status = BackgroundFetch.FETCH_RESULT_FAILED;
        debugPrint("Failed to check backup:\n${e.message}");
      }
      catch (e) {
        status = BackgroundFetch.FETCH_RESULT_FAILED;
        debugPrint("Failed to check backup:\n$e");
      }
      finally {
        debugPrint("Finishing backup procedure with status $status");
        BackgroundFetch.finish(status);
      }
  }

  static Future initialize() async {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true
      ), 
      _runBackupProcedure
    );
  }

  static Future<int> _backupCheck() async {
    debugPrint("_backupCheck begin");
    int result = BackgroundFetch.FETCH_RESULT_NO_DATA;
    var lastLocalBackupTime = await Preferences.getLastLocalBackup();
    var now = DateTime.now();
    if (lastLocalBackupTime == null 
      || now.difference(lastLocalBackupTime) > localBackupInterval) {
      await _createLocalBackup();
       result = BackgroundFetch.FETCH_RESULT_NEW_DATA;
    }

    var lastCloudBackupTime = await Preferences.getLastCloudBackup();

    var cloudBackupInterval = _getDuration(await Preferences.getCloudBackupInterval());
    if (lastCloudBackupTime == null
      || now.difference(lastCloudBackupTime) > cloudBackupInterval) {
      if (await _createCloudBackup())
      {
        result = BackgroundFetch.FETCH_RESULT_NEW_DATA;
      }
    }

    debugPrint("_backupCheck end");
    return result;
  }

  static Duration _getDuration(BackupInterval interval) {
    Duration result;
    switch (interval) {
      case BackupInterval.never:
      case BackupInterval.onClick:
        // 1000 years, or never.
        result = Duration(days: 365 * 1000);
        break;
      case BackupInterval.daily:
        result = Duration(days: 1);
        break;
      case BackupInterval.weekly:
        result = Duration(days: 7);
        break;
      case BackupInterval.monthly:
        // Thirty days is practically a month.
        result = Duration(days: 30);
        break;
    }

    return result;
  }

  static Future _createLocalBackup() async {
    debugPrint("_createLocalBackup begin.");
    var repo = Repository();
    
    var tempFile = File(await _tempBackupPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    tempFile = await File(await _tempBackupPath).create();
    var tempSink = tempFile.openWrite();

    try {
      bool moreData = true;
      bool first = true;
      int offset = 0;
      tempSink.write('[');
      while (moreData) {
        var backupItems = await repo.getBackupData(offset, _receiptsPerBatch);
        if (backupItems.length < _receiptsPerBatch) {
          moreData = false;
        }
        
        offset += _receiptsPerBatch;

        for (var backupItem in backupItems) {
          String json = jsonEncode(backupItem.toJson());

          if (first) {
            first = false;
          } else {
            tempSink.write(',');
          }

          tempSink.write(json);
        }

        // flush after every batch.
        await tempSink.flush();
      }

      tempSink.write(']');
      await tempSink.flush();
    } finally {
      await tempSink.close();
    }

    var backupFile = await tempFile.rename(await _backupPath);
    await Preferences.setLastLocalBackup(DateTime.now());
    await Preferences.setLastBackupSize(await backupFile.length());
    debugPrint("_createLocalBackup end.");
  }

  static Future<bool> _createCloudBackup() async {
    debugPrint("_createCloudBackup begin");
    var wifiPref = await Preferences.getBackupConnectionPref();
    var currentConnectivity = await Connectivity().checkConnectivity();
    if (currentConnectivity == ConnectivityResult.none
      || (wifiPref == BackupConnectionPref.wifiOnly
      && currentConnectivity != ConnectivityResult.wifi)) {
      return false;
    }

    bool madeBackup = false;
    var lastLocalBackup = await Preferences.getLastLocalBackup();
    if (await _uploadBackup()) {
      await Preferences.setLastCloudBackup(lastLocalBackup);
      madeBackup = true;
    }

    debugPrint("_createCloudBackup end");
    return madeBackup;
  }

  static Future<bool> _uploadBackup() async {
    // TODO: implement
    return false;
  }
}