import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart'; // Importe ton ApiService

class MachineDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxMap<dynamic, dynamic> _machine = <dynamic, dynamic>{}.obs;
  Timer? _timer;

  Map<dynamic, dynamic> get machine => _machine;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      _machine.value = Get.arguments;
      _startLiveUpdates(); // Lance la mise à jour automatique
    }
  }

  // Fonction qui appelle l'API en boucle
  void _startLiveUpdates() {
    // On récupère l'ID de la machine actuelle
    String? machineId = _machine['info']?['machine_id'] ?? _machine['machine_id'];

    if (machineId != null) {
      // Toutes le 3 secondes, on rafraîchit les données
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        try {
          final newData = await _apiService.getMachineDetails(machineId);
          _machine.value = newData;
          print("Update: ${newData['current']['temp_mean']}°C");
        } catch (e) {
          print("Erreur de mise à jour live: $e");
        }
      });
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); // TRÈS IMPORTANT : Arrêter le timer quand on quitte la page
    super.onClose();
  }

  // Ta fonction de transformation pour les graphiques

  List<FlSpot> getVibrationSpots() {
    final List<dynamic> history = _machine['history'] ?? [];
    return history.asMap().entries.map((e) => 
      FlSpot(e.key.toDouble(), (e.value['vib_mean'] ?? 0.0).toDouble())
    ).toList();
  }
}