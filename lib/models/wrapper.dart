import 'package:json_annotation/json_annotation.dart';
part 'wrapper.g.dart';

@JsonSerializable()
class Wrapper {
  Wrapper();

  String version;
  Map<String, dynamic> receipt;

  factory Wrapper.fromJson(Map<String, dynamic> json) => _$WrapperFromJson(json);
  Map<String, dynamic> toJson() => _$WrapperToJson(this);
}