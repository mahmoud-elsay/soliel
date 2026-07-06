// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_field_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionnaireFieldResultModel _$QuestionnaireFieldResultModelFromJson(
  Map<String, dynamic> json,
) => QuestionnaireFieldResultModel(
  fieldName: json['fieldName'] as String,
  score: (json['score'] as num).toDouble(),
  status: json['status'] as String,
);

Map<String, dynamic> _$QuestionnaireFieldResultModelToJson(
  QuestionnaireFieldResultModel instance,
) => <String, dynamic>{
  'fieldName': instance.fieldName,
  'score': instance.score,
  'status': instance.status,
};
