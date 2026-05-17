import 'package:json_annotation/json_annotation.dart';
import 'package:soliel/features/test/data/models/scan_point.dart';

part 'eye_scan_request.g.dart';

@JsonSerializable(explicitToJson: true)
class EyeScanRequest {
  final int childId;
  final String notes;
  final List<ScanPoint> scanPath;

  const EyeScanRequest({
    required this.childId,
    required this.notes,
    required this.scanPath,
  });

  factory EyeScanRequest.fromJson(Map<String, dynamic> json) =>
      _$EyeScanRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EyeScanRequestToJson(this);
}
