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

  bool get isHighRisk => asdProbability >= 0.75;
  bool get isModerateRisk => asdProbability >= 0.40 && asdProbability < 0.75;
  bool get isLowRisk => asdProbability < 0.40;

  double get normalizedAsdProbability {
    if (asdProbability < 0) return 0;
    if (asdProbability > 1) return 1;
    return asdProbability;
  }

  int get percentageInt => (normalizedAsdProbability * 100).round();

  int get confidencePercentageInt {
    if (confidence < 0) return 0;
    if (confidence > 1) return 100;
    return (confidence * 100).round();
  }
}
