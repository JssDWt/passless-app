import 'package:json_annotation/json_annotation.dart';
part 'backup_data.g.dart';

@JsonSerializable()
class BackupData {
  BackupData();

  String state;
  String base64Receipt;
  String notes;

  factory BackupData.fromJson(Map<String, dynamic> json) => _$BackupDataFromJson(json);
  Map<String, dynamic> toJson() => _$BackupDataToJson(this);
}