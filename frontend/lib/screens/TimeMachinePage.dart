



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/TimeMachineController.dart';
import '../widgets/app_bottom_bar.dart';

class TimeMachinePage extends StatelessWidget {
  final controller = Get.put(TimeMachineController());
  final int _currentIndex = 1;

   TimeMachinePage({super.key});

  // Correction 2 : Mise à jour de la logique de redirection
  void _onBottomTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0: 
        Get.offAllNamed('/home_page'); 
        break;
      case 1: 
        // Déjà sur History
        break; 
      case 2: 
        Get.offNamed('/alerts_page'); 
        break;
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