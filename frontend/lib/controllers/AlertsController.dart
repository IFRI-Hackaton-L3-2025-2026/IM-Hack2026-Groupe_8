import 'package:get/get.dart';
import '../services/api_service.dart';

class AlertsController extends GetxController {
  final ApiService api = ApiService();
  var isLoading = true.obs;
  var riskyAlerts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiskyMachines();
  }

  Future<void> fetchRiskyMachines() async {
    try {
      isLoading(true);
      final List<dynamic> data = await api.getAlerts();
      
      // On filtre et on force le cast en Map<String, dynamic>
      riskyAlerts.value = data.where((m) {
        bool isDown = m['status'] == "en panne";
        bool isRisky = m['failure_next_24h'] == 1;
        bool isMaintenance = (m['maintenance_age_days'] ?? 0) > 100;
        
        return isDown || isRisky || isMaintenance;
      }).map((e) => e as Map<String, dynamic>) // Convertit chaque élément
        .toList();

    } catch (e) {
      print("Erreur lors de la récupération : $e");
    } finally {
      isLoading(false);
    }
  }
}