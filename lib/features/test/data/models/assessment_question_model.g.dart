// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentQuestionModel _$AssessmentQuestionModelFromJson(
  Map<String, dynamic> json,
) => AssessmentQuestionModel(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  fieldName: json['fieldName'] as String,
);

Map<String, dynamic> _$AssessmentQuestionModelToJson(
  AssessmentQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'fieldName': instance.fieldName,
};
