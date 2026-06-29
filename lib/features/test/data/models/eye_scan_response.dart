import 'package:json_annotation/json_annotation.dart';

part 'eye_scan_response.g.dart';

@JsonSerializable()
class EyeScanResponse {
  final double asdProbability;
  final double tdProbability;
  final String result;
  final double confidence;
  final String recommendation;
  final int pointsAnalyzed;
  final String decision;

  const EyeScanResponse({
    required this.asdProbability,
    required this.tdProbability,
    required this.result,
    required this.confidence,
    required this.recommendation,
    required this.pointsAnalyzed,
    required this.decision,
  });

  factory EyeScanResponse.fromJson(Map<String, dynamic> json) =>
      _$EyeScanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EyeScanResponseToJson(this);

  bool get isHighRisk => normalizedAsdProbability >= 0.75;
  bool get isModerateRisk =>
      normalizedAsdProbability >= 0.40 && normalizedAsdProbability < 0.75;
  bool get isLowRisk => normalizedAsdProbability < 0.40;

  double get normalizedAsdProbability => _normalizeProbability(asdProbability);

  double get normalizedTdProbability => _normalizeProbability(tdProbability);

  double get normalizedConfidence => _normalizeProbability(confidence);

  double _normalizeProbability(double value) {
    if (value.isNaN || value.isInfinite || value < 0) return 0;
    if (value <= 1) return value;
    if (value <= 100) return value / 100;
    return 1;
  }

  int get percentageInt => (normalizedAsdProbability * 100).round();

  int get confidencePercentageInt {
    return (normalizedConfidence * 100).round();
  }
}
