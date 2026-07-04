// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_questionnaire_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitQuestionnaireRequest _$SubmitQuestionnaireRequestFromJson(
  Map<String, dynamic> json,
) => SubmitQuestionnaireRequest(
  childId: (json['childId'] as num).toInt(),
  answers: (json['answers'] as List<dynamic>)
      .map((e) => QuestionnaireAnswerModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubmitQuestionnaireRequestToJson(
  SubmitQuestionnaireRequest instance,
) => <String, dynamic>{
  'childId': instance.childId,
  'answers': instance.answers,
};

QuestionnaireAnswerModel _$QuestionnaireAnswerModelFromJson(
  Map<String, dynamic> json,
) => QuestionnaireAnswerModel(
  questionId: (json['questionId'] as num).toInt(),
  score: (json['score'] as num).toInt(),
);

Map<String, dynamic> _$QuestionnaireAnswerModelToJson(
  QuestionnaireAnswerModel instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'score': instance.score,
};
