// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestReportResponse _$LatestReportResponseFromJson(
  Map<String, dynamic> json,
) => LatestReportResponse(
  childName: json['childName'] as String,
  lastUpdated: json['lastUpdated'] as String,
  eyeScan: EyeScanReportModel.fromJson(json['eyeScan'] as Map<String, dynamic>),
  questionnaire: (json['questionnaire'] as List<dynamic>)
      .map(
        (e) =>
            QuestionnaireFieldResultModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  weakestField: json['weakestField'] as String,
  suggestedGame: json['suggestedGame'] as String?,
);

Map<String, dynamic> _$LatestReportResponseToJson(
  LatestReportResponse instance,
) => <String, dynamic>{
  'childName': instance.childName,
  'lastUpdated': instance.lastUpdated,
  'eyeScan': instance.eyeScan,
  'questionnaire': instance.questionnaire,
  'weakestField': instance.weakestField,
  'suggestedGame': instance.suggestedGame,
};
