import 'package:json_annotation/json_annotation.dart';

part 'assessment_question_model.g.dart';

@JsonSerializable()
class AssessmentQuestionModel {
  final int id;
  final String text;
  final String fieldName;

  const AssessmentQuestionModel({
    required this.id,
    required this.text,
    required this.fieldName,
  });

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentQuestionModelToJson(this);
}
