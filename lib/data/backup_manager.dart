import 'dart:convert';
import 'dart:io';

import 'package:passless/data/data_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupManager {
  static const String LAST_LOCAL_BACKUP = "lastLocalBackup";
  static const String LAST_CLOUD_BACKUP = "lastCloudBackup";
  static const String LAST_BACKUP_SIZE = "lastBackupSize";
  static const String CLOUD_BACKUP_INTERVAL = "cloudBackupInterval";
  static const String CLOUD_BACKUP_ACCOUNT = "cloudBackupAccount";
  static const String BACKUP_CONNECTION_PREF = "backupConnectionPref";

  static const int _receiptsPerBatch = 50;

  Future<String> get _backupPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/local_backup.json";
    return path;
  }

  Future<String> get _tempBackupPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/local_temp_backup.json";
    return path;
  }

  Future createLocalBackup() async {
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

        if (first) {
          first = false;
        } else {
          tempSink.write(',');
        }

        for (var backupItem in backupItems) {
          String json = jsonEncode(backupItem.toJson());
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
    var pref = await SharedPreferences.getInstance();
    await pref.setString(LAST_LOCAL_BACKUP, DateTime.now().toIso8601String());
    await pref.setInt(LAST_BACKUP_SIZE, await backupFile.length());
  }

  Future uploadLastBackup() async {
    // TODO: Upload the last backup.
  }
}