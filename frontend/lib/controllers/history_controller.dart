
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:frontend/services/api_service.dart';

class HistoryController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var showData = false.obs;
  var errorMessage = RxnString();

  var selectedDate = DateTime.now().obs;
  var telemetryData = <FlSpot>[].obs;
  // On stocke les objets complets pour afficher la vitesse dans le tooltip
  var rawDataList = <Map<String, dynamic>>[].obs; 

  double minX = 0;
  double maxX = 24;
  double minY = 0;
  double maxY = 120;

  Future<void> loadTelemetryData() async {
    isLoading.value = true;
    showData.value = false;
    errorMessage.value = null;

    try {
      String formattedDate =
          "${selectedDate.value.day.toString().padLeft(2, '0')}/"
          "${selectedDate.value.month.toString().padLeft(2, '0')}/"
          "${selectedDate.value.year}";

      final data = await apiService.getArchives(formattedDate);

      telemetryData.clear();
      rawDataList.clear();

      if (data.isEmpty) {
        errorMessage.value = "Aucune donnée disponible pour cette date";
        showData.value = false;
      } else {
        for (var item in data) {
          final timestamp = item["timestamp"] as String? ?? "";
          final temp = (item["temp_mean"] as num?)?.toDouble() ?? 0.0;

          if (timestamp.isEmpty) continue;

          final timeParts = timestamp.split(" ")[1].split(":");
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          final x = hour + minute / 60.0;

          telemetryData.add(FlSpot(x, temp));
          rawDataList.add(item); // On sauvegarde l'item complet
        }

        showData.value = true;

        if (telemetryData.isNotEmpty) {
          minY = telemetryData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5;
          maxY = telemetryData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5;
          minY = (minY / 10).floor() * 10.0;
          maxY = (maxY / 10).ceil() * 10.0;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
    isLoading.value = false;
  }
}