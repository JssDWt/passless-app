// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupData _$BackupDataFromJson(Map<String, dynamic> json) {
  return BackupData()
    ..state = json['state'] as String
    ..base64Receipt = json['base64Receipt'] as String
    ..notes = json['notes'] as String;
}

Map<String, dynamic> _$BackupDataToJson(BackupData instance) =>
    <String, dynamic>{
      'state': instance.state,
      'base64Receipt': instance.base64Receipt,
      'notes': instance.notes
    };
