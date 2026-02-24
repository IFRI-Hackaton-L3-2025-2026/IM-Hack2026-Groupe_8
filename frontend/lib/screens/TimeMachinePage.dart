// // import 'package:flutter/material.dart';
// // import 'package:frontend/widgets/app_bottom_bar.dart';
// // import 'package:get/get.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import '../controllers/TimeMachineController.dart';

// // class TimeMachinePage extends StatelessWidget {
// //   final controller = Get.put(TimeMachineController());
// //   final int _currentIndex = 2;

// //   @override
// //   Widget build(BuildContext context) {
// //     void _onBottomTap(int index) {
// //   if (index == _currentIndex) return;

// //   switch (index) {
// //     case 0:
// //       Get.offAllNamed('/home_page'); // Supprime la pile pour revenir au début
// //       break;
// //     case 1:
// //       Get.offNamed('/equipment_page'); // Remplace la page actuelle
// //       break;
// //     case 2:
// //       // Déjà sur History/TimeMachine
// //       break;
// //     case 3:
// //       Get.offNamed('/alerts');
// //       break;
// //   }
// // }
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0D1117),
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         title: const Text("Time Machine", style: TextStyle(color: Colors.white)),
// //         leading: const Icon(Icons.history, color: Colors.cyanAccent),
// //       ),

// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             _buildCard(
// //               title: "Select Date & Time",
// //               child: Column(
// //                 children: [
// //                   _buildInputRow("Date", true, context),
// //                   const SizedBox(height: 15),
// //                   _buildInputRow("Time", false, context),
// //                   const SizedBox(height: 20),
// //                   Obx(() => SizedBox(
// //                     width: double.infinity,
// //                     height: 50,
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.cyanAccent,
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                       ),
// //                       onPressed: controller.isLoading.value ? null : () => controller.fetchData(),
// //                       child: controller.isLoading.value 
// //                         ? const CircularProgressIndicator(color: Colors.black) 
// //                         : const Text("Load Historical Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
// //                     ),
// //                   )),
// //                 ],
// //               ),
// //             ),

// //             _buildCard(
// //               title: "Telemetry Data",
// //               child: Column(
// //                 children: [
// //                   Container(
// //                     height: 250,
// //                     padding: const EdgeInsets.only(top: 20, right: 20),
// //                     child: Obx(() => LineChart(_mainChartData())),
// //                   ),
// //                   const SizedBox(height: 25),
// //                   Obx(() => Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     children: [
// //                       _buildStat("Average", "${controller.avg.value}", Colors.white),
// //                       _buildStat("Peak", "${controller.peak.value}", Colors.orangeAccent),
// //                       _buildStat("Minimum", "${controller.min.value}", Colors.cyanAccent),
// //                     ],
// //                   )),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),

// //     );
// //   }

// //   LineChartData _mainChartData() {
// //   // Si on n'a pas de données, on affiche un écran vide propre
// //   if (controller.telemetryData.isEmpty) {
// //     return LineChartData(
// //       minX: 0, maxX: 1, minY: 0, maxY: 1,
// //       titlesData: const FlTitlesData(show: false),
// //       borderData: FlBorderData(show: false),
// //     );
// //   }

// //   // --- L'ASTUCE POUR ESPACER LE GRAPHE ---
// //   // On trouve la première et la dernière heure présente dans tes données
// //   double firstX = controller.telemetryData.first.x;
// //   double lastX = controller.telemetryData.last.x;

// //   // On ajoute une petite marge de sécurité (5 min avant/après) pour que ce soit beau
// //   double margin = 0.1; 

// //   return LineChartData(
// //     // On définit les limites dynamiquement selon tes données
// //     minX: firstX - margin,
// //     maxX: lastX + margin,
    
// //     gridData: FlGridData(
// //       show: true, 
// //       drawVerticalLine: true,
// //       getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
// //       getDrawingVerticalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
// //     ),
// //     titlesData: FlTitlesData(
// //       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //       bottomTitles: AxisTitles(
// //         sideTitles: SideTitles(
// //           showTitles: true,
// //           // On calcule l'intervalle pour avoir environ 5-6 labels maximum
// //           interval: (lastX - firstX == 0) ? 1 : (lastX - firstX) / 4,
// //           getTitlesWidget: (val, meta) {
// //             // Transforme le X décimal en HH:mm (ex: 10.5 -> 10:30)
// //             int h = val.toInt();
// //             int m = ((val - h) * 60).toInt();
// //             if (h < 0 || h > 23) return const SizedBox.shrink();
// //             return Padding(
// //               padding: const EdgeInsets.only(top: 10.0),
// //               child: Text(
// //                 "${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}",
// //                 style: const TextStyle(color: Colors.grey, fontSize: 10),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     ),
// //     borderData: FlBorderData(show: false),
// //     lineBarsData: [
// //       LineChartBarData(
// //         spots: controller.telemetryData.toList(),
// //         isCurved: true,
// //         curveSmoothness: 0.35,
// //         color: Colors.cyanAccent,
// //         barWidth: 3,
// //         isStrokeCapRound: true,
// //         dotData: const FlDotData(show: false),
// //         belowBarData: BarAreaData(
// //           show: true,
// //           gradient: LinearGradient(
// //             colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //       ),
// //     ],
// //   );
  
// // }

// //   // --- WIDGETS DE STYLE ---
// //   Widget _buildCard({required String title, required Widget child}) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       margin: const EdgeInsets.only(bottom: 20),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF161B22),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: Colors.white10),
// //       ),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //         const SizedBox(height: 20),
// //         child,
// //       ]),
// //     );
// //   }

// //   Widget _buildInputRow(String label, bool isDate, BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
// //         const SizedBox(height: 8),
// //         InkWell(
// //           onTap: () => isDate ? controller.pickDate(context) : controller.pickTime(context),
// //           child: Container(
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // SEUL LE TEXTE EST DANS OBX POUR EVITER L'ERREUR ROUGE
// //                 Obx(() => Text(
// //                   isDate ? controller.formattedDate : controller.formattedTime,
// //                   style: const TextStyle(color: Colors.white),
// //                 )),
// //                 Icon(isDate ? Icons.calendar_today : Icons.access_time, color: Colors.cyanAccent, size: 18),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStat(String label, String val, Color col) {
// //     return Column(children: [
// //       Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
// //       const SizedBox(height: 4),
// //       Text(val, style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.bold)),
// //     ]);
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../controllers/TimeMachineController.dart';
// import '../widgets/app_bottom_bar.dart';

// class TimeMachinePage extends StatelessWidget {
//   final controller = Get.put(TimeMachineController());
//   final int _currentIndex = 2;

//   void _onBottomTap(int index) {
//     if (index == _currentIndex) return;
//     switch (index) {
//       case 0: Get.offAllNamed('/home_page'); break;
//       case 1: Get.offNamed('/equipment_page'); break;
//       case 2: break; // Déjà ici
//       case 3: Get.offNamed('/alerts'); break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text("Time Machine", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         leading: const Icon(Icons.history, color: Colors.cyanAccent),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // --- SÉLECTION DATE & HEURE ---
//             _buildCard(
//               title: "1. Select Date & Time",
//               child: Column(
//                 children: [
//                   _buildInputRow("Date", true, context),
//                   const SizedBox(height: 15),
//                   _buildInputRow("Time", false, context),
//                 ],
//               ),
//             ),

//             // --- SÉLECTION DU CAPTEUR (CSV COLUMNS) ---
//             _buildCard(
//               title: "2. Select Sensor Data",
//               child: Obx(() => Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.black26,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.white12),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: controller.selectedColumn.value,
//                     dropdownColor: const Color(0xFF161B22),
//                     isExpanded: true,
//                     icon: const Icon(Icons.sensors, color: Colors.cyanAccent),
//                     style: const TextStyle(color: Colors.white),
//                     items: controller.sensorLabels.entries.map((e) => 
//                       DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
//                     onChanged: (val) {
//                       if (val != null) {
//                         controller.selectedColumn.value = val;
//                         controller.fetchData();
//                       }
//                     },
//                   ),
//                 ),
//               )),
//             ),

//             const SizedBox(height: 10),
            
//             // BOUTON CHARGER
//             Obx(() => SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
//                 onPressed: controller.isLoading.value ? null : () => controller.fetchData(),
//                 child: controller.isLoading.value 
//                   ? const CircularProgressIndicator(color: Colors.black) 
//                   : const Text("Load Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//               ),
//             )),

//             const SizedBox(height: 20),

//             _buildCard(
//   title: "Telemetry Visualization (Scroll to see more)",
//   child: Column(
//     children: [
//       // On utilise un SingleChildScrollView horizontal pour le défilement
//       SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//           // On multiplie la largeur pour "étaler" les données
//           // Plus ce chiffre est grand, plus tu "zoomes" sur les montagnes
//           width: MediaQuery.of(context).size.width * 3, 
//           height: 300,
//           padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
//           child: Obx(() => LineChart(_mainChartData())),
//         ),
//       ),
//       const SizedBox(height: 25),
//       // Tes stats en dessous...
//     ],
//   ),
// ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),
//     );
//   }

//   // LineChartData _mainChartData() {
//   //   if (controller.telemetryData.isEmpty) {
//   //     return LineChartData(minX: 0, maxX: 1, minY: 0, maxY: 1, titlesData: const FlTitlesData(show: false));
//   //   }

//   //   double firstX = controller.telemetryData.first.x;
//   //   double lastX = controller.telemetryData.last.x;
//   //   double margin = 0.1;

//   //   return LineChartData(
//   //     minX: firstX - margin,
//   //     maxX: lastX + margin,
//   //     gridData: FlGridData(show: true, drawVerticalLine: true, getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10)),
//   //     titlesData: FlTitlesData(
//   //       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//   //       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//   //       bottomTitles: AxisTitles(
//   //         sideTitles: SideTitles(
//   //           showTitles: true,
//   //           interval: (lastX - firstX == 0) ? 1 : (lastX - firstX) / 4,
//   //           getTitlesWidget: (val, meta) {
//   //             int h = val.toInt();
//   //             int m = ((val - h) * 60).toInt();
//   //             return Text("${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}", 
//   //                         style: const TextStyle(color: Colors.grey, fontSize: 10));
//   //           },
//   //         ),
//   //       ),
//   //     ),
//   //     borderData: FlBorderData(show: false),
//   //     lineBarsData: [
//   //       LineChartBarData(
//   //         spots: controller.telemetryData.toList(),
//   //         isCurved: true,
//   //         color: Colors.cyanAccent,
//   //         barWidth: 3,
//   //         dotData: const FlDotData(show: false),
//   //         belowBarData: BarAreaData(show: true, gradient: LinearGradient(
//   //           colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
//   //           begin: Alignment.topCenter, end: Alignment.bottomCenter,
//   //         )),
//   //       ),
//   //     ],
//   //   );
//   // }
//   LineChartData _mainChartData() {
//   if (controller.telemetryData.isEmpty) {
//     return LineChartData(
//       minX: 0, maxX: 1, minY: 0, maxY: 1, 
//       titlesData: const FlTitlesData(show: false)
//     );
//   }

//   double firstX = controller.telemetryData.first.x;
//   double lastX = controller.telemetryData.last.x;
  
//   // On trouve la valeur min et max sur l'axe Y pour l'échelle verticale
//   double minY = controller.min.value * 0.9; // 10% de marge en bas
//   double maxY = controller.peak.value * 1.1; // 10% de marge en haut

//   // Si l'écart est trop petit (ex: 0), on force une plage visible
//   if (maxY == minY) {
//     maxY += 5;
//     minY -= 5;
//   }

//   return LineChartData(
//     minX: firstX,
//     maxX: lastX,
//     minY: minY,
//     maxY: maxY,
    
//     // --- GRILLE PLUS ESPACÉE ---
//     gridData: FlGridData(
//       show: true,
//       drawVerticalLine: true,
//       horizontalInterval: (maxY - minY) / 4, // 4 lignes horizontales max
//       verticalInterval: (lastX - firstX) / 4, // 4 lignes verticales max
//       getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//       getDrawingVerticalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//     ),

//     titlesData: FlTitlesData(
//       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      
//       // --- AXE VERTICAL (VALEURS) ---
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40, // Espace pour les chiffres à gauche
//           interval: (maxY - minY) / 4,
//           getTitlesWidget: (val, meta) {
//             return Text(
//               val.toStringAsFixed(1), // Affiche 1 décale (ex: 65.2)
//               style: const TextStyle(color: Colors.grey, fontSize: 10),
//             );
//           },
//         ),
//       ),

//       // --- AXE HORIZONTAL (HH:mm) ---
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           interval: (lastX - firstX) / 4, // Espacement des labels
//           getTitlesWidget: (val, meta) {
//             int h = val.toInt();
//             int m = ((val - h) * 60).toInt();
//             // On s'assure que les minutes restent entre 0 et 59
//             if (m >= 60) { h++; m = 0; }
//             return Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}",
//                 style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             );
//           },
//         ),
//       ),
//     ),

//     borderData: FlBorderData(
//       show: true,
//       border: const Border(
//         bottom: BorderSide(color: Colors.white24, width: 1),
//         left: BorderSide(color: Colors.white24, width: 1),
//       ),
//     ),

//     lineBarsData: [
//       LineChartBarData(
//         spots: controller.telemetryData.toList(),
//         isCurved: true,
//         curveSmoothness: 0.3, // Courbe un peu plus tendue pour être plus lisible
//         color: Colors.cyanAccent,
//         barWidth: 3,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(show: false), // On cache les points pour épurer
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//             colors: [Colors.cyanAccent.withOpacity(0.2), Colors.transparent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//     ],
//   );
// }
//   Widget _buildCard({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 15),
//         child,
//       ]),
//     );
//   }

//   Widget _buildInputRow(String label, bool isDate, BuildContext context) {
//     return InkWell(
//       onTap: () => isDate ? controller.pickDate(context) : controller.pickTime(context),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Obx(() => Text(isDate ? controller.formattedDate : controller.formattedTime, style: const TextStyle(color: Colors.white))),
//           Icon(isDate ? Icons.calendar_today : Icons.access_time, color: Colors.cyanAccent, size: 18),
//         ]),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String val, Color col) {
//     return Column(children: [
//       Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
//       Text(val, style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.bold)),
//     ]);
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../controllers/TimeMachineController.dart';
// import '../widgets/app_bottom_bar.dart';

// class TimeMachinePage extends StatelessWidget {
//   final controller = Get.put(TimeMachineController());
//   final int _currentIndex = 2;

//   void _onBottomTap(int index) {
//     if (index == _currentIndex) return;
//     switch (index) {
//       case 0: Get.offAllNamed('/home_page'); break;
//       case 1: Get.offNamed('/equipment_page'); break;
//       case 2: break;
//       case 3: Get.offNamed('/alerts'); break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text("Time Machine", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 1. Sélecteurs (Date, Heure, Capteur)
//             _buildCard(
//               title: "Configuration",
//               child: Column(
//                 children: [
//                   _buildInputRow("Date", true, context),
//                   const SizedBox(height: 10),
//                   _buildInputRow("Time", false, context),
//                   const SizedBox(height: 15),
//                   _buildSensorDropdown(),
//                   const SizedBox(height: 15),
//                   _buildLoadButton(),
//                 ],
//               ),
//             ),

//             // 2. LE GRAPHIQUE ZOOMÉ ET SCROLLABLE
//             _buildCard(
//               title: "Live Analysis (Scroll horizontally →)",
//               child: Column(
//                 children: [
//                   // L'astuce est ici : SingleChildScrollView + Container très large
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Obx(() {
//                       // On définit une largeur fixe proportionnelle au nombre de points
//                       // ou simplement 3 fois la largeur de l'écran pour "étaler"
//                       double chartWidth = MediaQuery.of(context).size.width * 3.5;
                      
//                       return Container(
//                         width: controller.telemetryData.isEmpty ? MediaQuery.of(context).size.width : chartWidth,
//                         height: 350,
//                         padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
//                         child: LineChart(_mainChartData()),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildStatsRow(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),
//     );
//   }

//   // --- LOGIQUE DU GRAPHIQUE (ZOOM & MONTAGNES) ---
//   LineChartData _mainChartData() {
//     if (controller.telemetryData.isEmpty) {
//       return LineChartData(minX: 0, maxX: 1, minY: 0, maxY: 1, titlesData: const FlTitlesData(show: false));
//     }

//     double firstX = controller.telemetryData.first.x;
//     double lastX = controller.telemetryData.last.x;

//     return LineChartData(
//       minX: firstX,
//       maxX: lastX,
//       minY: controller.min.value * 0.95, // Zoom vertical serré
//       maxY: controller.peak.value * 1.05,
      
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//         getDrawingVerticalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//       ),

//       titlesData: FlTitlesData(
//         topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         // Valeurs à gauche (Axe Y)
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 45,
//             getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 10)),
//           ),
//         ),
//         // Temps en bas (Axe X) - Toutes les 5 minutes
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 0.083, // 5 minutes (5/60)
//             getTitlesWidget: (val, meta) {
//               int h = val.toInt();
//               int m = ((val - h) * 60).round();
//               if (m == 60) { h++; m = 0; }
//               return Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text("${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}", 
//                             style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
//               );
//             },
//           ),
//         ),
//       ),

//       borderData: FlBorderData(show: true, border: Border.all(color: Colors.white10)),

//       lineBarsData: [
//         LineChartBarData(
//           spots: controller.telemetryData.toList(),
//           isCurved: true,
//           curveSmoothness: 0.1, // Moins de lissage pour voir les vrais pics
//           // preventCurveOverShooting: true, // TRÈS IMPORTANT : empêche la courbe de faire des nœuds bizarres
//           color: Colors.cyanAccent,
//           barWidth: 2.5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(show: false), // On cache les points pour épurer
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // --- WIDGETS DE STYLE ---

//   Widget _buildSensorDropdown() {
//     return Obx(() => Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: controller.selectedColumn.value,
//           dropdownColor: const Color(0xFF161B22),
//           isExpanded: true,
//           style: const TextStyle(color: Colors.white),
//           items: controller.sensorLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
//           onChanged: (val) => controller.selectedColumn.value = val!,
//         ),
//       ),
//     ));
//   }

//   Widget _buildLoadButton() {
//     return Obx(() => SizedBox(
//       width: double.infinity,
//       height: 45,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//         onPressed: controller.isLoading.value ? null : () => controller.fetchData(),
//         child: controller.isLoading.value 
//           ? const CircularProgressIndicator(color: Colors.black) 
//           : const Text("LOAD DATA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//       ),
//     ));
//   }

//   Widget _buildStatsRow() {
//     return Obx(() => Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildStat("AVERAGE", "${controller.avg.value}", Colors.white),
//         _buildStat("PEAK", "${controller.peak.value}", Colors.orangeAccent),
//         _buildStat("MINIMUM", "${controller.min.value}", Colors.cyanAccent),
//       ],
//     ));
//   }

//   Widget _buildCard({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
//         const SizedBox(height: 15),
//         child,
//       ]),
//     );
//   }

//   Widget _buildInputRow(String label, bool isDate, BuildContext context) {
//     return InkWell(
//       onTap: () => isDate ? controller.pickDate(context) : controller.pickTime(context),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           Obx(() => Text(isDate ? controller.formattedDate : controller.formattedTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         ]),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String val, Color col) {
//     return Column(children: [
//       Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
//       const SizedBox(height: 4),
//       Text(val, style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.bold)),
//     ]);
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../controllers/TimeMachineController.dart';
// import '../widgets/app_bottom_bar.dart';

// class TimeMachinePage extends StatelessWidget {
//   final controller = Get.put(TimeMachineController());
//   final int _currentIndex = 2;

//   void _onBottomTap(int index) {
//     if (index == _currentIndex) return;
//     switch (index) {
//       case 0: Get.offAllNamed('/home_page'); break;
//       case 1: Get.offNamed('/equipment_page'); break;
//       case 2: break;
//       case 3: Get.offNamed('/alerts'); break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text("Time Machine", 
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 1. SÉLECTEURS (Date, Heure, Machine, Capteur)
//             _buildCard(
//               title: "Configuration",
//               child: Column(
//                 children: [
//                   _buildInputRow("Date", true, context),
//                   const SizedBox(height: 10),
//                   _buildInputRow("Time", false, context),
//                   const SizedBox(height: 15),
//                   _buildMachineIdInput(), // NOUVEAU : Pour filtrer le CSV
//                   const SizedBox(height: 10),
//                   _buildSensorDropdown(),
//                   const SizedBox(height: 15),
//                   _buildLoadButton(),
//                 ],
//               ),
//             ),

//             // 2. LE GRAPHIQUE ZOOMÉ ET SCROLLABLE
//             _buildCard(
//               title: "Archive Analysis (Scroll horizontal →)",
//               child: Column(
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Obx(() {
//                       // Largeur dynamique : si pas de données, largeur écran, sinon étalé
//                       double chartWidth = controller.telemetryData.isEmpty 
//                           ? MediaQuery.of(context).size.width 
//                           : MediaQuery.of(context).size.width * 3.5;
                      
//                       return Container(
//                         width: chartWidth,
//                         height: 350,
//                         padding: const EdgeInsets.only(top: 20, right: 30, bottom: 10),
//                         child: LineChart(_mainChartData()),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildStatsRow(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),
//     );
//   }

//   // --- LOGIQUE DU GRAPHIQUE ---
//   LineChartData _mainChartData() {
//     if (controller.telemetryData.isEmpty) {
//       return LineChartData(
//         minX: 0, maxX: 1, minY: 0, maxY: 1, 
//         titlesData: const FlTitlesData(show: false),
//         gridData: const FlGridData(show: false),
//       );
//     }

//     double firstX = controller.telemetryData.first.x;
//     double lastX = controller.telemetryData.last.x;

//     return LineChartData(
//       minX: firstX,
//       maxX: lastX,
//       minY: controller.min.value * 0.9, // Marge basse
//       maxY: controller.peak.value * 1.1, // Marge haute
      
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//         getDrawingVerticalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
//       ),

//       titlesData: FlTitlesData(
//         topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 45,
//             getTitlesWidget: (val, meta) => Text(
//               val.toStringAsFixed(1), 
//               style: const TextStyle(color: Colors.grey, fontSize: 10)
//             ),
//           ),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 0.25, // Un label toutes les 15 minutes
//             getTitlesWidget: (val, meta) {
//               int h = val.toInt();
//               int m = ((val - h) * 60).round();
//               if (m >= 60) { h++; m = 0; }
//               return Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text("${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}", 
//                   style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
//               );
//             },
//           ),
//         ),
//       ),

//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//           getTooltipItems: (spots) => spots.map((s) => LineTooltipItem("${s.y.toStringAsFixed(2)}", const TextStyle(color: Colors.white))).toList(),
//         ),
//       ),

//       borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),

//       lineBarsData: [
//         LineChartBarData(
//           spots: controller.telemetryData.toList(),
//           isCurved: true,
//           curveSmoothness: 0.15, 
//           preventCurveOverShooting: true, // EMPÊCHE LES BOUCLES BIZARRES
//           color: Colors.cyanAccent,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(show: false),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // --- WIDGETS DE COMPOSANTS ---

//   Widget _buildMachineIdInput() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
//       child: TextField(
//         style: const TextStyle(color: Colors.white, fontSize: 14),
//         onChanged: (val) => controller.selectedMachineId.value = val.toUpperCase(),
//         decoration: const InputDecoration(
//           labelText: "ID Machine (ex: CONV_01)",
//           labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
//           border: InputBorder.none,
//           icon: Icon(Icons.settings_remote, color: Colors.cyanAccent, size: 18),
//         ),
//       ),
//     );
//   }

//   Widget _buildSensorDropdown() {
//     return Obx(() => Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: controller.selectedColumn.value,
//           dropdownColor: const Color(0xFF161B22),
//           isExpanded: true,
//           icon: const Icon(Icons.analytics, color: Colors.cyanAccent),
//           style: const TextStyle(color: Colors.white),
//           items: controller.sensorLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
//           onChanged: (val) => controller.selectedColumn.value = val!,
//         ),
//       ),
//     ));
//   }

//   Widget _buildLoadButton() {
//     return Obx(() => SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.cyanAccent, 
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           elevation: 0,
//         ),
//         onPressed: controller.isLoading.value ? null : () => controller.fetchData(),
//         child: controller.isLoading.value 
//           ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) 
//           : const Text("ANALYZER L'HISTORIQUE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//       ),
//     ));
//   }

//   Widget _buildStatsRow() {
//     return Obx(() => Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildStat("MOYENNE", "${controller.avg.value}", Colors.white),
//         _buildStat("PIC MAX", "${controller.peak.value}", Colors.orangeAccent),
//         _buildStat("MINIMUM", "${controller.min.value}", Colors.cyanAccent),
//       ],
//     ));
//   }

//   Widget _buildCard({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
//         const SizedBox(height: 15),
//         child,
//       ]),
//     );
//   }

//   Widget _buildInputRow(String label, bool isDate, BuildContext context) {
//     return InkWell(
//       onTap: () => isDate ? controller.pickDate(context) : controller.pickTime(context),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Row(children: [
//             Icon(isDate ? Icons.calendar_today : Icons.access_time, color: Colors.grey, size: 16),
//             const SizedBox(width: 8),
//             Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           ]),
//           Obx(() => Text(
//             isDate ? controller.formattedDate : controller.formattedTime, 
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
//           )),
//         ]),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String val, Color col) {
//     return Column(children: [
//       Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
//       const SizedBox(height: 4),
//       Text(val, style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.bold)),
//     ]);
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/TimeMachineController.dart';
import '../widgets/app_bottom_bar.dart';

class TimeMachinePage extends StatelessWidget {
  final controller = Get.put(TimeMachineController());
  final int _currentIndex = 2;

   TimeMachinePage({super.key});

  void _onBottomTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0: Get.offAllNamed('/home_page'); break;
      case 1: Get.offNamed('/equipment_page'); break;
      case 2: break;
      case 3: Get.offNamed('/alerts_page'); break;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Time Machine", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. SÉLECTEURS (Configuration)
            _buildCard(
              title: "Configuration",
              child: Column(
                children: [
                  _buildInputRow("Date", true, context),
                  const SizedBox(height: 10),
                  _buildInputRow("Heure de début", false, context),
                  const SizedBox(height: 15),
                  _buildMachineDropdown(), // DROPDOWN DYNAMIQUE ICI
                  const SizedBox(height: 10),
                  _buildSensorDropdown(),
                  const SizedBox(height: 15),
                  _buildLoadButton(),
                ],
              ),
            ),

            // 2. LE GRAPHIQUE
            _buildCard(
              title: "Analyse Temporelle (Scroll horizontal →)",
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      double chartWidth = controller.telemetryData.isEmpty 
                          ? MediaQuery.of(context).size.width - 64
                          : MediaQuery.of(context).size.width * 3.5;
                      
                      return Container(
                        width: chartWidth,
                        height: 350,
                        padding: const EdgeInsets.only(top: 20, right: 30, bottom: 10),
                        child: LineChart(_mainChartData()),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),
    );
  }

  // --- WIDGET : DROPDOWN DES MACHINES (DYNAMIQUE) ---
  Widget _buildMachineDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black26, 
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(color: Colors.white12)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.availableMachines.contains(controller.selectedMachineId.value) 
              ? controller.selectedMachineId.value 
              : null,
          hint: const Text("Charger les données d'abord...", 
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          dropdownColor: const Color(0xFF161B22),
          isExpanded: true,
          icon: const Icon(Icons.precision_manufacturing, color: Colors.cyanAccent),
          style: const TextStyle(color: Colors.white),
          items: controller.availableMachines.map((String machine) {
            return DropdownMenuItem<String>(
              value: machine,
              child: Text(machine, style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.selectedMachineId.value = val;
              controller.fetchData(); // Met à jour le graphique dès qu'on change de machine
            }
          },
        ),
      ),
    ));
  }

LineChartData _mainChartData() {
  // 1. Cas où il n'y a pas de données
  if (controller.telemetryData.isEmpty) {
    return LineChartData(
      minX: 0, maxX: 1, minY: 0, maxY: 1,
      titlesData: const FlTitlesData(show: false),
      gridData: const FlGridData(show: false),
    );
  }

  // 2. Synchronisation avec l'heure sélectionnée (ex: 14:45)
  // On récupère l'heure du sélecteur convertie en double
  double minX = controller.startTimeAsDouble;
  
  // Fenêtre de vue très serrée : on affiche seulement les 30 prochaines minutes
  // (0.5 heure = 30 min). Augmente à +1.0 si tu veux voir 1 heure.
  double maxX = minX + 0.5; 

  // 3. Ajustement automatique de l'axe vertical pour éviter les chevauchements
  double chartMinY = (controller.min.value - 2).floorToDouble();
  double chartMaxY = (controller.peak.value + 2).ceilToDouble();

  return LineChartData(
    minX: minX,
    maxX: maxX,
    minY: chartMinY,
    maxY: chartMaxY,
    
    // Grille ultra-précise (une ligne toutes les 5 minutes)
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 5,
      verticalInterval: 0.083, // 5 / 60 = 0.083 (une ligne toutes les 5 min)
      getDrawingHorizontalLine: (v) => FlLine(color: Colors.white10, strokeWidth: 1),
      getDrawingVerticalLine: (v) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 0.5),
    ),

    titlesData: FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      
      // Axe Vertical : Valeurs espacées de 5 en 5 pour éviter les collisions
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 5, 
          getTitlesWidget: (val, meta) => Text(
            val.toStringAsFixed(0),
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ),

      // Axe Horizontal : Rapproché et synchronisé sur ton heure
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          // Un label toutes les 5 minutes pour un rendu très dense
          interval: 0.083, 
          getTitlesWidget: (val, meta) {
            // Sécurité : on n'affiche rien en dehors de la zone choisie
            if (val < minX - 0.01 || val > maxX + 0.01) return const SizedBox();

            int h = val.toInt();
            int m = ((val - h) * 60).round();
            if (m >= 60) { h++; m = 0; }
            if (h >= 24) h = 0;

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8.0,
              child: Text(
                "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.cyanAccent, 
                  fontSize: 8, 
                  fontWeight: FontWeight.bold
                ),
              ),
            );
          },
        ),
      ),
    ),

    lineBarsData: [
      LineChartBarData(
        spots: controller.telemetryData.toList(),
        isCurved: true,
        curveSmoothness: 0.1,
        color: Colors.cyanAccent,
        barWidth: 3,
        isStrokeCapRound: true,
        // Affichage des points de données pour bien marquer chaque minute
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.cyanAccent,
            strokeWidth: 1,
            strokeColor: Colors.black,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [Colors.cyanAccent.withOpacity(0.2), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ],

    // Tooltip pour voir la valeur exacte au toucher
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: const Color(0xFF1C2128),
        getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
          s.y.toStringAsFixed(1),
          const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        )).toList(),
      ),
    ),
  );
}

// Fonction utilitaire pour des points plus discrets
FlDotPainter _getDotPainter(FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
  return FlDotCirclePainter(
    radius: 2,
    color: Colors.cyanAccent,
    strokeWidth: 1,
    strokeColor: Colors.black,
  );
}
  // --- AUTRES COMPOSANTS UI ---

  Widget _buildSensorDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedColumn.value,
          dropdownColor: const Color(0xFF161B22),
          isExpanded: true,
          icon: const Icon(Icons.analytics, color: Colors.cyanAccent),
          style: const TextStyle(color: Colors.white),
          items: controller.sensorLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: (val) {
             controller.selectedColumn.value = val!;
             if(controller.availableMachines.isNotEmpty) controller.fetchData();
          },
        ),
      ),
    ));
  }

  Widget _buildLoadButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: controller.isLoading.value ? null : () => controller.fetchData(),
        child: controller.isLoading.value 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) 
          : const Text("CHARGER L'HISTORIQUE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    ));
  }

  Widget _buildStatsRow() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat("MOYENNE", "${controller.avg.value}", Colors.white),
        _buildStat("PIC MAX", "${controller.peak.value}", Colors.orangeAccent),
        _buildStat("MINIMUM", "${controller.min.value}", Colors.cyanAccent),
      ],
    ));
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 15),
        child,
      ]),
    );
  }

  Widget _buildInputRow(String label, bool isDate, BuildContext context) {
    return InkWell(
      onTap: () => isDate ? controller.pickDate(context) : controller.pickTime(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(isDate ? Icons.calendar_today : Icons.access_time, color: Colors.grey, size: 16),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Obx(() => Text(isDate ? controller.formattedDate : controller.formattedTime, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ]),
      ),
    );
  }

  Widget _buildStat(String label, String val, Color col) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
      const SizedBox(height: 4),
      Text(val, style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
  }
}