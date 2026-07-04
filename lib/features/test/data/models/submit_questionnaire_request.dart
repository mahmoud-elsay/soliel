import 'package:json_annotation/json_annotation.dart';

part 'submit_questionnaire_request.g.dart';

@JsonSerializable()
class SubmitQuestionnaireRequest {
  final int childId;
  final List<QuestionnaireAnswerModel> answers;

  const SubmitQuestionnaireRequest({
    required this.childId,
    required this.answers,
  });

  factory SubmitQuestionnaireRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitQuestionnaireRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitQuestionnaireRequestToJson(this);
}

@JsonSerializable()
class QuestionnaireAnswerModel {
  final int questionId;
  final int score;

  const QuestionnaireAnswerModel({
    required this.questionId,
    required this.score,
  });

  factory QuestionnaireAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireAnswerModelToJson(this);
}
