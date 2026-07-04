import 'package:json_annotation/json_annotation.dart';

part 'submit_questionnaire_response.g.dart';

@JsonSerializable()
class SubmitQuestionnaireResponse {
  final String message;
  final List<QuestionnaireSummaryModel> summary;

  const SubmitQuestionnaireResponse({
    required this.message,
    required this.summary,
  });

  factory SubmitQuestionnaireResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitQuestionnaireResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitQuestionnaireResponseToJson(this);
}

@JsonSerializable()
class QuestionnaireSummaryModel {
  final int fieldId;
  final String score;

  const QuestionnaireSummaryModel({required this.fieldId, required this.score});

  factory QuestionnaireSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireSummaryModelToJson(this);
}
