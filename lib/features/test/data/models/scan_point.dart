class ScanPoint {
  final double x;
  final double y;
  final int duration;

  const ScanPoint({
    required this.x,
    required this.y,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'duration': duration,
  };
}
