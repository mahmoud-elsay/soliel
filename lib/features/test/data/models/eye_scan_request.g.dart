// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_scan_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EyeScanRequest _$EyeScanRequestFromJson(Map<String, dynamic> json) =>
    EyeScanRequest(
      childId: (json['childId'] as num).toInt(),
      notes: json['notes'] as String,
      scanPath: (json['scanPath'] as List<dynamic>)
          .map((e) => ScanPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EyeScanRequestToJson(EyeScanRequest instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'notes': instance.notes,
      'scanPath': instance.scanPath.map((e) => e.toJson()).toList(),
    };
