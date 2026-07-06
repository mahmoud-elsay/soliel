import 'package:json_annotation/json_annotation.dart';

part 'questionnaire_field_result_model.g.dart';

@JsonSerializable()
class QuestionnaireFieldResultModel {
  final String fieldName;
  final double score;
  final String status;

  const QuestionnaireFieldResultModel({
    required this.fieldName,
    required this.score,
    required this.status,
  });

  factory QuestionnaireFieldResultModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireFieldResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireFieldResultModelToJson(this);
}
