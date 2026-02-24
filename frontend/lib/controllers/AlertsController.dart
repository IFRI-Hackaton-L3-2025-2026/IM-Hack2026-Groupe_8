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

 // Dans AlertsController.dart

Future<void> fetchRiskyMachines() async {
  try {
    isLoading(true);
    // Utilise directement getAlerts() qui filtre déjà les machines non-actives
    final List<dynamic> data = await api.getAlerts(); 
    
    print("Données reçues de l'API: ${data.length} machines détectées");

    // Filtrage ultra-large pour attraper toutes les anomalies de ton Python
    riskyAlerts.value = data.map((e) => e as Map<String, dynamic>).toList();

    if (riskyAlerts.isEmpty) {
      print("INFO: Aucune machine n'est en panne ou en warning actuellement.");
    }
  } catch (e) {
    print("ERREUR AlertsController: $e");
  } finally {
    isLoading(false);
  }
}
}