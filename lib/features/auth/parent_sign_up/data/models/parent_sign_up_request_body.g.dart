// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_sign_up_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentSignUpRequestBody _$ParentSignUpRequestBodyFromJson(
  Map<String, dynamic> json,
) => ParentSignUpRequestBody(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  relation: json['relation'] as String,
);

Map<String, dynamic> _$ParentSignUpRequestBodyToJson(
  ParentSignUpRequestBody instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'relation': instance.relation,
};
