import 'dart:async';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';



class MachineDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxMap<dynamic, dynamic> _machine = <dynamic, dynamic>{}.obs;
  Timer? _timer;

  Map<dynamic, dynamic> get machine => _machine;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      // On initialise avec les données reçues de la page précédente
      _machine.value = Get.arguments;
      _startLiveUpdates(); 
    }
  }

  // --- 1. FONCTION DE RAFRAÎCHISSEMENT (Celle qui manquait) ---
  Future<void> fetchMachineDetails(String machineId) async {
    try {
      final newData = await _apiService.getMachineDetails(machineId);
      _machine.value = newData; 
      _machine.refresh(); // On force GetX à signaler le changement
    } catch (e) {
      print("Erreur lors de la récupération des détails: $e");
    }
  }

  // --- 2. LOGIQUE DE MAINTENANCE ---
  Future<void> toggleMaintenanceOnServer(String machineId) async {
    try {
      // On utilise GetConnect pour envoyer le POST au Python
      final response = await GetConnect().post(
        'http://10.0.2.2:5000/api/maintenance/$machineId', 
        {},
      );

      if (response.statusCode == 200) {
        // Une fois que le serveur a validé, on recharge les données
        await fetchMachineDetails(machineId); 
        
        Get.snackbar(
          "Succès", 
          "Statut de maintenance mis à jour",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white
        );
      }
    } catch (e) {
      print("Erreur maintenance: $e");
      Get.snackbar("Erreur", "Impossible de contacter le serveur");
    }
  }

  // --- 3. UPDATES AUTOMATIQUES ---
  void _startLiveUpdates() {
    String? machineId = _machine['info']?['machine_id'] ?? _machine['machine_id'];

    if (machineId != null) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await fetchMachineDetails(machineId);
      });
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); 
    super.onClose();
  }

  List<FlSpot> getVibrationSpots() {
    final List<dynamic> history = _machine['history'] ?? [];
    if (history.isEmpty) return [const FlSpot(0, 0)];
    return history.asMap().entries.map((e) => 
      FlSpot(e.key.toDouble(), (e.value['vib_mean'] ?? 0.0).toDouble())
    ).toList();
  }
}