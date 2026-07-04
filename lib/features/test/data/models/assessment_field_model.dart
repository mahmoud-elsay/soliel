import 'package:json_annotation/json_annotation.dart';

part 'assessment_field_model.g.dart';

@JsonSerializable()
class AssessmentFieldModel {
  final int id;
  final String name;

  const AssessmentFieldModel({required this.id, required this.name});

  factory AssessmentFieldModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentFieldModelToJson(this);
}
