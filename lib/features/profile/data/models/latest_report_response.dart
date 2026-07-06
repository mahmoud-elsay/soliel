import 'package:json_annotation/json_annotation.dart';
import 'package:soliel/features/profile/data/models/eye_scan_report_model.dart';
import 'package:soliel/features/profile/data/models/questionnaire_field_result_model.dart';

part 'latest_report_response.g.dart';

@JsonSerializable()
class LatestReportResponse {
  final String childName;
  final String lastUpdated;
  final EyeScanReportModel? eyeScan;
  final List<QuestionnaireFieldResultModel>? questionnaire;
  final String? weakestField;
  final String? suggestedGame;

  const LatestReportResponse({
    required this.childName,
    required this.lastUpdated,
    this.eyeScan,
    this.questionnaire,
    this.weakestField,
    this.suggestedGame,
  });

  factory LatestReportResponse.fromJson(Map<String, dynamic> json) =>
      _$LatestReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LatestReportResponseToJson(this);
}
