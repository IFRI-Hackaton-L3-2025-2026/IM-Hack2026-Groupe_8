// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart'; // Vérifie ton chemin

// class TimeMachineController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var selectedDate = DateTime.now().obs;
//   var selectedTime = TimeOfDay.now().obs;

//   // Initialiser avec une liste vide pour éviter les erreurs de rendu
//   var telemetryData = <FlSpot>[].obs;
//   var avg = 0.0.obs;
//   var peak = 0.0.obs;
//   var min = 0.0.obs;

//   String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate.value);
//   String get formattedTime => "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}";

//   Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) selectedDate.value = picked;
//   }

//   Future<void> pickTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime.value,
//     );
//     if (picked != null) selectedTime.value = picked;
//   }

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       // On envoie la date formatée attendue par ton Python
//       final data = await apiService.getArchives(formattedDate);
      
//       if (data != null && data is List) {
//         List<FlSpot> newSpots = [];
//         List<double> values = [];

//         for (var item in data) {
//           final timestamp = item["timestamp"] as String? ?? "";
//           final temp = (item["temp_mean"] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.contains(" ")) {
//             final timeStr = timestamp.split(" ")[1];
//             final parts = timeStr.split(":");
//             final h = double.parse(parts[0]);
//             final m = double.parse(parts[1]);
            
//             // Calcul de l'axe X (Heure + fraction de minute)
//             final x = h + (m / 60.0);
//             newSpots.add(FlSpot(x, temp));
//             values.add(temp);
//           }
//         }

//         // Tri pour éviter que la ligne du graphique ne revienne en arrière
//         newSpots.sort((a, b) => a.x.compareTo(b.x));
//         telemetryData.assignAll(newSpots);

//         if (values.isNotEmpty) {
//           avg.value = double.parse((values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
//           peak.value = values.reduce((a, b) => a > b ? a : b);
//           min.value = values.reduce((a, b) => a < b ? a : b);
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Erreur", "Vérifiez votre serveur Flask ou l'IP",
//           backgroundColor: Colors.red.withOpacity(0.7), colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';

// class TimeMachineController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var selectedDate = DateTime.now().obs;
//   var selectedTime = TimeOfDay.now().obs;

//   // Colonne sélectionnée par défaut
//   var selectedColumn = "temp_mean".obs;

//   // Données du graphique et statistiques
//   var telemetryData = <FlSpot>[].obs;
//   var avg = 0.0.obs;
//   var peak = 0.0.obs;
//   var min = 0.0.obs;

//   // Dictionnaire pour afficher des noms propres à l'utilisateur
//   final Map<String, String> sensorLabels = {
//     "temp_mean": "Température (°C)",
//     "vib_mean": "Vibrations (mm/s)",
//     "current_mean": "Courant (A)",
//     "rpm_mean": "Vitesse (RPM)",
//     "oil_particle_count": "Particules Huile",
//   };

//   String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate.value);
//   String get formattedTime => "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}";

//   Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) selectedDate.value = picked;
//   }

//   Future<void> pickTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime.value,
//     );
//     if (picked != null) selectedTime.value = picked;
//   }

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       final data = await apiService.getArchives(formattedDate);
      
//       if (data != null && data is List) {
//         List<FlSpot> newSpots = [];
//         List<double> values = [];

//         for (var item in data) {
//           final timestamp = item["timestamp"] as String? ?? "";
          
//           // On récupère la valeur selon la colonne choisie (temp_mean, vib_mean, etc.)
//           final val = (item[selectedColumn.value] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.contains(" ")) {
//             final timeStr = timestamp.split(" ")[1];
//             final parts = timeStr.split(":");
//             final h = double.parse(parts[0]);
//             final m = double.parse(parts[1]);
//             final x = h + (m / 60.0);

//             newSpots.add(FlSpot(x, val));
//             values.add(val);
//           }
//         }

//         // Tri crucial pour éviter les bugs d'affichage
//         newSpots.sort((a, b) => a.x.compareTo(b.x));
//         // 2. On filtre pour ne garder qu'un seul point par X (le premier rencontré)
// // Cela évite les traits verticaux que l'on voit sur ton image
// final uniqueSpots = <FlSpot>[];
// if (newSpots.isNotEmpty) {
//   uniqueSpots.add(newSpots.first);
//   for (int i = 1; i < newSpots.length; i++) {
//     // Si le X est différent du précédent, on l'ajoute
//     if (newSpots[i].x != newSpots[i - 1].x) {
//       uniqueSpots.add(newSpots[i]);
//     }
//   }
// }
//         // newSpots.sort((a, b) => a.x.compareTo(b.x));
//         telemetryData.assignAll(newSpots);

//         if (values.isNotEmpty) {
//           avg.value = double.parse((values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
//           peak.value = double.parse(values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1));
//           min.value = double.parse(values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1));
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Erreur", "Impossible de charger les colonnes du CSV");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';

// class TimeMachineController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var selectedDate = DateTime.now().obs;
//   var selectedTime = TimeOfDay.now().obs;

//   // Filtres
//   var selectedColumn = "temp_mean".obs;
//   var selectedMachineId = "CONV_01".obs; // Machine par défaut

//   // Données
//   var telemetryData = <FlSpot>[].obs;
//   var avg = 0.0.obs;
//   var peak = 0.0.obs;
//   var min = 0.0.obs;

//   final Map<String, String> sensorLabels = {
//     "temp_mean": "Température (°C)",
//     "vib_mean": "Vibrations (mm/s)",
//     "current_mean": "Courant (A)",
//     "rpm_mean": "Vitesse (RPM)",
//     "oil_particle_count": "Particules Huile",
//   };

//   String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate.value);
//   String get formattedTime => "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}";

//   Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) selectedDate.value = picked;
//   }

//   Future<void> pickTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime.value,
//     );
//     if (picked != null) selectedTime.value = picked;
//   }

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       final data = await apiService.getArchives(formattedDate);
      
//       if (data != null && data is List) {
//         List<FlSpot> newSpots = [];
//         List<double> values = [];

//         for (var item in data) {
//           // FILTRE PAR MACHINE : Crucial car le CSV contient plusieurs machines à la même heure
//           if (item["machine_id"] != selectedMachineId.value) continue;

//           final timestamp = item["timestamp"] as String? ?? "";
//           final val = (item[selectedColumn.value] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.contains(" ")) {
//             final timeStr = timestamp.split(" ")[1];
//             final parts = timeStr.split(":");
//             final h = double.parse(parts[0]);
//             final m = double.parse(parts[1]);
//             final x = h + (m / 60.0);

//             newSpots.add(FlSpot(x, val));
//             values.add(val);
//           }
//         }

//         // 1. TRI PAR X
//         newSpots.sort((a, b) => a.x.compareTo(b.x));

//         // 2. NETTOYAGE DES DOUBLONS (Un seul point par minute pour éviter les traits verticaux)
//         final uniqueSpots = <FlSpot>[];
//         if (newSpots.isNotEmpty) {
//           uniqueSpots.add(newSpots.first);
//           for (int i = 1; i < newSpots.length; i++) {
//             if (newSpots[i].x != newSpots[i - 1].x) {
//               uniqueSpots.add(newSpots[i]);
//             }
//           }
//         }

//         telemetryData.assignAll(uniqueSpots);

//         if (values.isNotEmpty) {
//           avg.value = double.parse((values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
//           peak.value = double.parse(values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1));
//           min.value = double.parse(values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1));
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Erreur", "Problème lors du traitement des données");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';

// class TimeMachineController extends GetxController {
//   final ApiService apiService = ApiService();

//   var isLoading = false.obs;
//   var selectedDate = DateTime.now().obs;
//   var selectedTime = TimeOfDay.now().obs;

//   // Filtres
//   var selectedColumn = "temp_mean".obs;
//   var selectedMachineId = "".obs; 
//   var availableMachines = <String>[].obs; // La liste des IDs du CSV

//   // Données
//   var telemetryData = <FlSpot>[].obs;
//   var avg = 0.0.obs;
//   var peak = 0.0.obs;
//   var min = 0.0.obs;

//   final Map<String, String> sensorLabels = {
//     "temp_mean": "Température (°C)",
//     "vib_mean": "Vibrations (mm/s)",
//     "current_mean": "Courant (A)",
//     "rpm_mean": "Vitesse (RPM)",
//     "oil_particle_count": "Particules Huile",
//   };

//   String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate.value);
//   String get formattedTime => "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}";
//   @override
//   void onInit() {
//     super.onInit();
//     // Dès que la page s'ouvre, on va chercher la liste des machines
//     loadDropdownData(); 
//   }
//   Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate.value, firstDate: DateTime(2020), lastDate: DateTime(2030));
//     if (picked != null) selectedDate.value = picked;
//   }

//   Future<void> pickTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime.value);
//     if (picked != null) selectedTime.value = picked;
//   }

//   Future<void> loadDropdownData() async {
//     try {
//       isLoading.value = true;
//       // Correction : on utilise apiService (le nom défini en haut de ta classe)
//       List<String> machines = await apiService.getAvailableMachines(); 
      
//       if (machines.isNotEmpty) {
//         availableMachines.assignAll(machines);
//         if (selectedMachineId.value.isEmpty) {
//           selectedMachineId.value = machines.first;
//         }
//         fetchData(); 
//       }
//     } catch (e) {
//       print("Erreur chargement dropdown: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     try {
//       final data = await apiService.getArchives(formattedDate);
      
//       if (data != null && data is List) {
//         // --- LOGIQUE D'EXTRACTION ---
//         final machines = data
//             .map((e) => e["machine_id"]?.toString() ?? "")
//             .where((id) => id.isNotEmpty)
//             .toSet()
//             .toList();
//         machines.sort();
        
//         availableMachines.assignAll(machines);
//         print("Machines détectées : $availableMachines"); // VERIFICATION CONSOLE

//         if (selectedMachineId.value.isEmpty && availableMachines.isNotEmpty) {
//           selectedMachineId.value = availableMachines.first;
//         }

//         // --- FILTRAGE DES POINTS ---
//         List<FlSpot> newSpots = [];
//         List<double> values = [];

//         for (var item in data) {
//           if (item["machine_id"] != selectedMachineId.value) continue;

//           final timestamp = item["timestamp"] as String? ?? "";
//           final val = (item[selectedColumn.value] as num?)?.toDouble() ?? 0.0;

//           if (timestamp.contains(" ")) {
//             final timeStr = timestamp.split(" ")[1];
//             final parts = timeStr.split(":");
//             final x = double.parse(parts[0]) + (double.parse(parts[1]) / 60.0);
//             newSpots.add(FlSpot(x, val));
//             values.add(val);
//           }
//         }

//         newSpots.sort((a, b) => a.x.compareTo(b.x));
        
//         // Nettoyage doublons X
//         final uniqueSpots = <FlSpot>[];
//         if (newSpots.isNotEmpty) {
//           uniqueSpots.add(newSpots.first);
//           for (int i = 1; i < newSpots.length; i++) {
//             if (newSpots[i].x != newSpots[i - 1].x) uniqueSpots.add(newSpots[i]);
//           }
//         }

//         telemetryData.assignAll(uniqueSpots);

//         if (values.isNotEmpty) {
//           avg.value = double.parse((values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
//           peak.value = double.parse(values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1));
//           min.value = double.parse(values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1));
//         }
//       }
//     } catch (e) {
//       print("Erreur Fetch: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class TimeMachineController extends GetxController {
  final ApiService apiService = ApiService();

  // États de l'UI
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  // Filtres et Sélection
  var selectedColumn = "temp_mean".obs;
  var selectedMachineId = "".obs; 
  var availableMachines = <String>[].obs; 

  // Données du Graphique et Stats
  var telemetryData = <FlSpot>[].obs;
  var avg = 0.0.obs;
  var peak = 0.0.obs;
  var min = 0.0.obs;

  final Map<String, String> sensorLabels = {
    "temp_mean": "Température (°C)",
    "vib_mean": "Vibrations (mm/s)",
    "current_mean": "Courant (A)",
    "rpm_mean": "Vitesse (RPM)",
    "oil_particle_count": "Particules Huile",
  };

  // Getters pour l'affichage
  String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate.value);
  String get formattedTime => "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}";
double get startTimeAsDouble => selectedTime.value.hour + (selectedTime.value.minute / 60.0);
  @override
  void onInit() {
    super.onInit();
    // Au démarrage, on charge d'abord la liste des machines disponibles
    loadDropdownData(); 
  }

  // --- SELECTION DATE / HEURE ---
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: selectedDate.value, 
      firstDate: DateTime(2020), 
      lastDate: DateTime(2030)
    );
    if (picked != null) {
      selectedDate.value = picked;
      fetchData(); // Recharger les données quand la date change
    }
  }

  // --- CHARGEMENT DU DROPDOWN (Global) ---
  Future<void> loadDropdownData() async {
    try {
      isLoading.value = true;
      List<String> machines = await apiService.getAvailableMachines(); 
      
      if (machines.isNotEmpty) {
        availableMachines.assignAll(machines);
        // On sélectionne la première machine par défaut
        if (selectedMachineId.value.isEmpty || !availableMachines.contains(selectedMachineId.value)) {
          selectedMachineId.value = machines.first;
        }
        // Une fois les machines chargées, on va chercher les données du graphique
        await fetchData(); 
      }
    } catch (e) {
      print("Erreur chargement dropdown: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- RÉCUPÉRATION DES POINTS DU GRAPHIQUE ---
  Future<void> fetchData() async {
    if (selectedMachineId.value.isEmpty) return;

    isLoading.value = true;
    try {
      // On récupère les archives pour la date sélectionnée
      final data = await apiService.getArchives(formattedDate);
      
      if (data is List) {
        List<FlSpot> newSpots = [];
        List<double> values = [];

        for (var item in data) {
          // On ne garde que les données de la machine sélectionnée
          if (item["machine_id"] != selectedMachineId.value) continue;

          final timestamp = item["timestamp"] as String? ?? "";
          final val = (item[selectedColumn.value] as num?)?.toDouble() ?? 0.0;

          // Extraction de l'heure pour l'axe X (format "YYYY-MM-DD HH:mm:ss")
          if (timestamp.contains(" ")) {
            try {
              final timeStr = timestamp.split(" ")[1];
              final parts = timeStr.split(":");
              // Conversion en double (ex: 14h30 -> 14.5) pour fl_chart
              final x = double.parse(parts[0]) + (double.parse(parts[1]) / 60.0);
              
              newSpots.add(FlSpot(x, val));
              values.add(val);
            } catch (e) {
              continue; // Format de date invalide
            }
          }
        }

        // Tri et nettoyage des doublons sur l'axe X
        newSpots.sort((a, b) => a.x.compareTo(b.x));
        final uniqueSpots = <FlSpot>[];
        if (newSpots.isNotEmpty) {
          uniqueSpots.add(newSpots.first);
          for (int i = 1; i < newSpots.length; i++) {
            if (newSpots[i].x != newSpots[i - 1].x) uniqueSpots.add(newSpots[i]);
          }
        }

        // Mise à jour de la liste réactive pour le graphique
        telemetryData.assignAll(uniqueSpots);

        // Calcul des statistiques
        if (values.isNotEmpty) {
          avg.value = double.parse((values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
          peak.value = double.parse(values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1));
          min.value = double.parse(values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1));
        } else {
          // Reset si aucune donnée trouvée pour cette machine à cette date
          avg.value = 0.0; peak.value = 0.0; min.value = 0.0;
        }
      }
    } catch (e) {
      print("Erreur Fetch Data: $e");
      telemetryData.clear();
    } finally {
      isLoading.value = false;
    }
  }


  // --- SELECTION DE L'HEURE ---
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: selectedTime.value
    );
    if (picked != null) {
      selectedTime.value = picked;
      // Optionnel : Tu peux aussi filtrer fetchData si tu veux 
      // restreindre le graphique à une heure précise.
    }
  }
}