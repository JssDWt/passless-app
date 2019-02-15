import 'package:flutter/foundation.dart';
import 'package:passless/data/backup_connection_pref.dart';
import 'package:passless/data/backup_interval.dart';
import 'package:passless/data/data_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String LAST_LOCAL_BACKUP = "lastLocalBackup";
  static const String LAST_CLOUD_BACKUP = "lastCloudBackup";
  static const String LAST_BACKUP_SIZE = "lastBackupSize";
  static const String CLOUD_BACKUP_INTERVAL = "cloudBackupInterval";
  static const String CLOUD_BACKUP_ACCOUNT = "cloudBackupAccount";
  static const String BACKUP_CONNECTION_PREF = "backupConnectionPref";

  static Future<SharedPreferences> get _pref async 
    => await SharedPreferences.getInstance(); 

  static Future<DateTime> getLastLocalBackup() async {
    String time = (await _pref).getString(LAST_LOCAL_BACKUP);
    if (time == null) return null;
    return DateTime.parse(time);
  }

  static Future<bool> setLastLocalBackup(DateTime backupTime) async {
    String time = backupTime.toIso8601String();
    return await (await _pref).setString(LAST_LOCAL_BACKUP, time);
  }

  static Future<DateTime> getLastCloudBackup() async {
    String time = (await _pref).getString(LAST_CLOUD_BACKUP);
    if (time == null) return null;
    return DateTime.parse(time);
  }

  static Future<bool> setLastCloudBackup(DateTime backupTime) async {
    String time = backupTime.toIso8601String();
    return await (await _pref).setString(LAST_CLOUD_BACKUP, time);
  }

  static Future<int> getLastBackupSize() async {
    return (await _pref).getInt(LAST_BACKUP_SIZE);
  }

  static Future<bool> setLastBackupSize(int backupSize) async {
    return (await _pref).setInt(LAST_BACKUP_SIZE, backupSize);
  }

  static Future<BackupInterval> getCloudBackupInterval() async {
    String interval = (await _pref).getString(CLOUD_BACKUP_INTERVAL);
    if (interval == null) return BackupInterval.never;

    BackupInterval result;
    switch (interval) {
      case "never":
        result = BackupInterval.never;
        break;
      case "onClick":
        result = BackupInterval.onClick;
        break;
      case "daily":
        result = BackupInterval.daily;
        break;
      case "weekly":
        result = BackupInterval.weekly;
        break;
      case "monthly":
        result = BackupInterval.monthly;
        break;
      default:
        throw DataException("Invalid backup interval '$interval' stored in shared preferences.");
    }

    return result;
  }

  static Future<bool> setCloudBackupInterval(BackupInterval interval) async {
    return (await _pref).setString(CLOUD_BACKUP_INTERVAL, describeEnum(interval));
  }

  static Future<String> getCloudBackupAccount() async {
    return (await _pref).getString(CLOUD_BACKUP_ACCOUNT);
  }

  static Future<bool> setCloudBackupAccount(String account) async {
    return (await _pref).setString(CLOUD_BACKUP_ACCOUNT, account);
  }

  static Future<BackupConnectionPref> getBackupConnectionPref() async {
    String connPref = (await _pref).getString(BACKUP_CONNECTION_PREF);
    if (connPref == null) return BackupConnectionPref.wifiOnly;

    BackupConnectionPref result;
    switch (connPref) {
      case "wifiOnly":
        result = BackupConnectionPref.wifiOnly;
        break;
      case "wifiOrMobileNetwork":
        result = BackupConnectionPref.wifiOrMobileNetwork;
        break;
      default:
        throw DataException("Invalid backup connection pref '$connPref' stored in shared preferences.");
    }

    return result;
  }

  static Future<bool> setBackupConnectionPref(BackupConnectionPref connPref) async {
    return (await _pref).setString(BACKUP_CONNECTION_PREF, describeEnum(connPref));
  }
}