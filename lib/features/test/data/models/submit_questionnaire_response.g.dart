// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_questionnaire_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitQuestionnaireResponse _$SubmitQuestionnaireResponseFromJson(
  Map<String, dynamic> json,
) => SubmitQuestionnaireResponse(
  message: json['message'] as String,
  summary: (json['summary'] as List<dynamic>)
      .map((e) => QuestionnaireSummaryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubmitQuestionnaireResponseToJson(
  SubmitQuestionnaireResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'summary': instance.summary,
};

QuestionnaireSummaryModel _$QuestionnaireSummaryModelFromJson(
  Map<String, dynamic> json,
) => QuestionnaireSummaryModel(
  fieldId: (json['fieldId'] as num).toInt(),
  score: json['score'] as String,
);

Map<String, dynamic> _$QuestionnaireSummaryModelToJson(
  QuestionnaireSummaryModel instance,
) => <String, dynamic>{'fieldId': instance.fieldId, 'score': instance.score};
