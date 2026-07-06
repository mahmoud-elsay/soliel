// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildResponse _$AddChildResponseFromJson(Map<String, dynamic> json) =>
    AddChildResponse(
      message: json['message'] as String,
      childId: (json['childId'] as num).toInt(),
    );

Map<String, dynamic> _$AddChildResponseToJson(AddChildResponse instance) =>
    <String, dynamic>{'message': instance.message, 'childId': instance.childId};
