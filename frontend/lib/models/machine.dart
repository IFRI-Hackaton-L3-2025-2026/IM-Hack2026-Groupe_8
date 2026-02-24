class Machine {
  final String id;
  final String name;
  final String brand;
  final String type;
  final String status;

  Machine({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.status,
  });

  /// Convert API → Object Flutter
  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json["machine_id"],
      name: json["name"],
      brand: json["brand"],
      type: json["machine_type"],
      status: json["status"],
    );
  }

  /// Normalisation UI
  String get uiStatus {
    switch (status.toLowerCase()) {
      case "active":
        return "Active";

      case "warning":
        return "Maintenance";

      case "en panne":
        return "Fault";

      default:
        return "Unknown";
    }
  }
}