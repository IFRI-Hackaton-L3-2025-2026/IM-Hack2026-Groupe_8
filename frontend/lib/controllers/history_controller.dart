
// import 'package:fl_chart/fl_chart.dart';
// import 'package:get/get.dart';
// import 'package:frontend/services/api_service.dart';

// class HistoryController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var showData = false.obs;
//   var errorMessage = RxnString();

//   var selectedDate = DateTime.now().obs;
//   var telemetryData = <FlSpot>[].obs;
//   // On stocke les objets complets pour afficher la vitesse dans le tooltip
//   var rawDataList = <Map<String, dynamic>>[].obs; 

//   double minX = 0;
//   double maxX = 24;
//   double minY = 0;
//   double maxY = 120;

//   Future<void> loadTelemetryData() async {
//     isLoading.value = true;
//     showData.value = false;
//     errorMessage.value = null;

//     try {
//       String formattedDate =
//           "${selectedDate.value.day.toString().padLeft(2, '0')}/"
//           "${selectedDate.value.month.toString().padLeft(2, '0')}/"
//           "${selectedDate.value.year}";

//       final data = await apiService.getArchives(formattedDate);

//       telemetryData.clear();
//       rawDataList.clear();

//       if (data.isEmpty) {
//         errorMessage.value = "Aucune donnée disponible pour cette date";
//         showData.value = false;
//       } else {
//         for (var item in data) {
//           final timestamp = item["timestamp"] as String? ?? "";
//           final temp = (item["temp_mean"] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.isEmpty) continue;

//           final timeParts = timestamp.split(" ")[1].split(":");
//           final hour = int.tryParse(timeParts[0]) ?? 0;
//           final minute = int.tryParse(timeParts[1]) ?? 0;
//           final x = hour + minute / 60.0;

//           telemetryData.add(FlSpot(x, temp));
//           rawDataList.add(item); // On sauvegarde l'item complet
//         }

//         showData.value = true;

//         if (telemetryData.isNotEmpty) {
//           minY = telemetryData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5;
//           maxY = telemetryData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5;
//           minY = (minY / 10).floor() * 10.0;
//           maxY = (maxY / 10).ceil() * 10.0;
//         }
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     }
//     isLoading.value = false;
//   }
// }

// import 'package:fl_chart/fl_chart.dart';
// import 'package:get/get.dart';
// import 'package:frontend/services/api_service.dart';

// class HistoryController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var showData = false.obs;
//   var errorMessage = RxnString();

//   var selectedDate = DateTime.now().obs;
//   var telemetryData = <FlSpot>[].obs;
//   var rawDataList = <Map<String, dynamic>>[].obs; 

//   double minY = 0;
//   double maxY = 100;

//   Future<void> loadTelemetryData() async {
//     isLoading.value = true;
//     showData.value = false;
//     errorMessage.value = null;

//     try {
//       String formattedDate =
//           "${selectedDate.value.day.toString().padLeft(2, '0')}/"
//           "${selectedDate.value.month.toString().padLeft(2, '0')}/"
//           "${selectedDate.value.year}";

//       final data = await apiService.getArchives(formattedDate);

//       telemetryData.clear();
//       rawDataList.clear();

//       if (data.isEmpty) {
//         errorMessage.value = "Aucune donnée disponible pour cette date";
//       } else {
//         for (var item in data) {
//           final timestamp = item["timestamp"] as String? ?? "";
//           final temp = (item["temp_mean"] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.isEmpty) continue;

//           // Split pour obtenir HH:mm:ss
//           final timeParts = timestamp.split(" ")[1].split(":");
//           final hour = int.tryParse(timeParts[0]) ?? 0;
//           final minute = int.tryParse(timeParts[1]) ?? 0;
//           final second = (timeParts.length > 2) ? (int.tryParse(timeParts[2]) ?? 0) : 0;

//           // Calcul de X ultra-précis (Heure + décimales des minutes et secondes)
//           final x = hour + (minute / 60.0) + (second / 3600.0);

//           telemetryData.add(FlSpot(x, temp));
//           rawDataList.add(Map<String, dynamic>.from(item));
//         }

//         // Ajustement automatique des axes Y
//         if (telemetryData.isNotEmpty) {
//           double rawMinY = telemetryData.map((e) => e.y).reduce((a, b) => a < b ? a : b);
//           double rawMaxY = telemetryData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
//           minY = (rawMinY - 5).clamp(0, 200);
//           maxY = rawMaxY + 5;
//         }
//         showData.value = true;
//       }
//     } catch (e) {
//       errorMessage.value = "Erreur de connexion : $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/services/api_service.dart';

class HistoryController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var showData = false.obs;
  var errorMessage = RxnString();

  var selectedDate = DateTime.now().obs;

  var telemetryData = <FlSpot>[].obs;
  var rawDataList = <Map<String, dynamic>>[].obs;

  double minX = 0;
  double maxX = 24;
  double minY = 0;
  double maxY = 100;

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
        return;
      }

      for (var item in data) {
        final timestamp = item["timestamp"] as String? ?? "";
        if (timestamp.isEmpty) continue;

        try {
          final parts = timestamp.split(" ");
          if (parts.length < 2) continue;

          final timeParts = parts[1].split(":");

          final hour = double.parse(timeParts[0]);
          final minute = double.parse(timeParts[1]);
          final second =
              (timeParts.length > 2) ? double.parse(timeParts[2]) : 0.0;

          final x = hour + (minute / 60.0) + (second / 3600.0);
          final temp =
              (item["temp_mean"] as num?)?.toDouble() ?? 0.0;

          telemetryData.add(FlSpot(x, temp));
          rawDataList.add(Map<String, dynamic>.from(item));
        } catch (_) {}
      }

      if (telemetryData.isEmpty) {
        errorMessage.value = "Données invalides";
        return;
      }

      // ---- AUTO SCALE X ----
      telemetryData.sort((a, b) => a.x.compareTo(b.x));

      minX = telemetryData.first.x;
      maxX = telemetryData.last.x;

      if (minX == maxX) {
        minX -= 0.5;
        maxX += 0.5;
      } else {
        final paddingX = (maxX - minX) * 0.05;
        minX -= paddingX;
        maxX += paddingX;
      }
      // ✅ Empêche les valeurs négatives
if (minX < 0) {
  minX = 0;
}

      // ---- AUTO SCALE Y ----
      double rawMinY =
          telemetryData.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      double rawMaxY =
          telemetryData.map((e) => e.y).reduce((a, b) => a > b ? a : b);

      if (rawMinY == rawMaxY) {
        minY = rawMinY - 5;
        maxY = rawMaxY + 5;
      } else {
        final paddingY = (rawMaxY - rawMinY) * 0.05;
        minY = rawMinY - paddingY;
        maxY = rawMaxY + paddingY;
      }

      showData.value = true;
    } catch (e) {
      errorMessage.value = "Erreur : $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Format lisible pour l'axe X
  String formatHour(double value) {
    int hour = value.floor();
    int minute = ((value - hour) * 60).round();
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}





