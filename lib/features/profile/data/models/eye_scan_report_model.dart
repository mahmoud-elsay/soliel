import 'package:json_annotation/json_annotation.dart';

part 'eye_scan_report_model.g.dart';

@JsonSerializable()
class EyeScanReportModel {
  final double asdProbability;
  final double tdProbability;
  final String result;
  final double confidence;
  final String decision;
  final String date;

  const EyeScanReportModel({
    required this.asdProbability,
    required this.tdProbability,
    required this.result,
    required this.confidence,
    required this.decision,
    required this.date,
  });

  factory EyeScanReportModel.fromJson(Map<String, dynamic> json) =>
      _$EyeScanReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeScanReportModelToJson(this);
}
