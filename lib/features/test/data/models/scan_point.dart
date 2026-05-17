import 'package:json_annotation/json_annotation.dart';

part 'scan_point.g.dart';

@JsonSerializable()
class ScanPoint {
  final int idx;
  final double x;
  final double y;
  final int duration;

  const ScanPoint({
    required this.idx,
    required this.x,
    required this.y,
    required this.duration,
  });

  factory ScanPoint.fromJson(Map<String, dynamic> json) =>
      _$ScanPointFromJson(json);

  Map<String, dynamic> toJson() => _$ScanPointToJson(this);
}
