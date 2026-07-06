// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_scan_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EyeScanReportModel _$EyeScanReportModelFromJson(Map<String, dynamic> json) =>
    EyeScanReportModel(
      asdProbability: (json['asdProbability'] as num).toDouble(),
      tdProbability: (json['tdProbability'] as num).toDouble(),
      result: json['result'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      decision: json['decision'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$EyeScanReportModelToJson(EyeScanReportModel instance) =>
    <String, dynamic>{
      'asdProbability': instance.asdProbability,
      'tdProbability': instance.tdProbability,
      'result': instance.result,
      'confidence': instance.confidence,
      'decision': instance.decision,
      'date': instance.date,
    };
