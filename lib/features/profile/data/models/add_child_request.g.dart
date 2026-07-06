// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildRequest _$AddChildRequestFromJson(Map<String, dynamic> json) =>
    AddChildRequest(
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$AddChildRequestToJson(AddChildRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
    };
