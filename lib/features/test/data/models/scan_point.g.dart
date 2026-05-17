// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanPoint _$ScanPointFromJson(Map<String, dynamic> json) => ScanPoint(
  idx: (json['idx'] as num).toInt(),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$ScanPointToJson(ScanPoint instance) => <String, dynamic>{
  'idx': instance.idx,
  'x': instance.x,
  'y': instance.y,
  'duration': instance.duration,
};
