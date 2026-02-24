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
      // Utilise getMachines() ou getAlerts() selon ce qui renvoie le statut à jour
      final List<dynamic> data = await api.getMachines(); 
      
      // FILTRAGE CORRIGÉ
      riskyAlerts.value = data.where((m) {
        // 1. La machine est en panne
        bool isDown = m['status'] == "en panne";
        
        // 2. La machine est officiellement en maintenance (via ton API)
        bool isMaintenance = m['status'] == "maintenance";
        
        // 3. (Optionnel) L'IA prédit une panne (si tu veux garder l'alerte prédictive)
        bool isRisky = m['failure_next_24h'] == 1;
        
        return isDown || isMaintenance || isRisky;
      }).map((e) => e as Map<String, dynamic>)
        .toList();

    } catch (e) {
      print("Erreur lors de la récupération : $e");
    } finally {
      isLoading(false);
    }
  }
}