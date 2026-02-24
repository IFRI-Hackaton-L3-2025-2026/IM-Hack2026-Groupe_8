class TelemetryEvent {
  final String timestamp;
  final String equipment;
  final String eventType;
  final String duration;
  final double average;
  final double peak;
  final double minimum;

  TelemetryEvent({
    required this.timestamp,
    required this.equipment,
    required this.eventType,
    required this.duration,
    required this.average,
    required this.peak,
    required this.minimum,
  });
}