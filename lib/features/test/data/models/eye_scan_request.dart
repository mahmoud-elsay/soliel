import 'package:soliel/features/test/data/models/scan_point.dart';

class EyeScanRequest {
  final int childId;
  final String notes;
  final List<ScanPoint> scanPath;

  const EyeScanRequest({
    required this.childId,
    required this.notes,
    required this.scanPath,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'notes': notes,
    'scanPath': scanPath.map((e) => e.toJson()).toList(),
  };
}
