// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_scan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EyeScanResponse _$EyeScanResponseFromJson(Map<String, dynamic> json) =>
    EyeScanResponse(
      asdProbability: (json['asdProbability'] as num).toDouble(),
      tdProbability: (json['tdProbability'] as num).toDouble(),
      result: json['result'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      pointsAnalyzed: (json['pointsAnalyzed'] as num).toInt(),
      decision: json['decision'] as String,
    );

Map<String, dynamic> _$EyeScanResponseToJson(EyeScanResponse instance) =>
    <String, dynamic>{
      'asdProbability': instance.asdProbability,
      'tdProbability': instance.tdProbability,
      'result': instance.result,
      'confidence': instance.confidence,
      'recommendation': instance.recommendation,
      'pointsAnalyzed': instance.pointsAnalyzed,
      'decision': instance.decision,
    };
