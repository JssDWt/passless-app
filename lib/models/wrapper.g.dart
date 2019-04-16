// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wrapper _$WrapperFromJson(Map<String, dynamic> json) {
  return Wrapper()
    ..version = json['version'] as String
    ..receipt = json['receipt'] as Map<String, dynamic>;
}

Map<String, dynamic> _$WrapperToJson(Wrapper instance) =>
    <String, dynamic>{'version': instance.version, 'receipt': instance.receipt};
