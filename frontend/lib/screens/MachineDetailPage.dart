import 'package:flutter/material.dart';
import 'package:frontend/controllers/MachineDetailsController.Dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
// Vérifie bien que le nom du fichier controller est exact (minuscules recommandées)

class EquipmentDetailPage extends StatelessWidget {
  const EquipmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère le controller (qui a été injecté lors de la navigation)
final MachineDetailsController controller = Get.put(MachineDetailsController());
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.machine['info']?['name'] ?? "Chargement...",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        )),
        actions: [
          Obx(() => _buildStatusChip(controller.machine['current']?['status'])),
          const SizedBox(width: 15),
        ],
      ),
      
      // Le corps de la page est enveloppé dans Obx pour réagir aux changements du JSON
      body: Obx(() {
        // On extrait les données ici, à l'intérieur du Obx
        final info = controller.machine['info'] ?? {};
        final current = controller.machine['current'] ?? {};

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION INFOS GÉNÉRALES (Type, Brand, ID) ---
              _buildTopInfoSection(info, current),
              const SizedBox(height: 25),
              
              const Text(
                "Real-Time Sensors",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // --- VIBRATION (Graphique) ---
              _buildSensorCard(
                title: "Vibration Monitor",
                subtitle: "IMU/VTX100",
                value: "${current['vib_mean'] ?? 0} mm/s",
                icon: Icons.vibration,
                color: Colors.cyanAccent,
                child: _buildWaveChart(Colors.cyanAccent, controller.getVibrationSpots()),
              ),

              // --- TEMPERATURE (Jauge) ---
              _buildSensorCard(
                title: "Temperature Sensor",
                subtitle: "OMEGA-CX-MINI",
                value: "${current['temp_mean'] ?? 0}°C",
                icon: Icons.thermostat,
                color: Colors.orangeAccent,
                child: _buildTempGauge(current['temp_mean']?.toDouble() ?? 0.0),
              ),

              // --- RPM (Jauge circulaire) ---
              _buildSensorCard(
                title: "Rotary Encoder",
                subtitle: "RPN-1500",
                value: "${current['rpm_mean'] ?? 0} RPM",
                icon: Icons.autorenew,
                color: Colors.greenAccent,
                child: _buildRpmGauge(current['rpm_mean']?.toDouble() ?? 0.0),
              ),
            ],
          ),
        );
      }),

      // --- SECTION BAS DE PAGE (Bouton Maintenance) ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
  final machineId = controller.machine['info']['machine_id'];
  controller.toggleMaintenanceOnServer(machineId);
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.build, color: Colors.black),
                  label: const Text(
                    "METTRE EN  MAINTENANCE",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (Structure) ---

  Widget _buildTopInfoSection(Map info, Map current) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Type", info['machine_type'] ?? "N/A"),
              _infoItem("Brand", info['brand'] ?? "N/A"),
              _infoItem("ID", info['machine_id'] ?? "N/A"),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Maint. Age", "${current['maintenance_age_days'] ?? 0} days"),
              _infoItem("Predicted Fail", current['failure_next_24h'] == 1 ? "YES" : "NO"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildSensorCard({required String title, required String subtitle, required String value, required IconData icon, required Color color, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // --- GRAPHICS ---

  Widget _buildWaveChart(Color color, List<FlSpot> spots) {
    return SizedBox(
      height: 80,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempGauge(double temp) {
    return SizedBox(
      height: 100,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0, maximum: 120, showLabels: false, showTicks: false,
            startAngle: 180, endAngle: 0, canScaleToFit: true,
            axisLineStyle: const AxisLineStyle(thickness: 8, color: Colors.white10),
            pointers: <GaugePointer>[
              RangePointer(value: temp, width: 8, color: Colors.orangeAccent, cornerStyle: CornerStyle.bothCurve),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRpmGauge(double rpm) {
    return SizedBox(
      height: 100,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0, maximum: 2000, showLabels: false, showTicks: false,
            axisLineStyle: const AxisLineStyle(thickness: 4, color: Colors.white10),
            pointers: <GaugePointer>[
              RangePointer(value: rpm, width: 4, color: Colors.greenAccent),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Text("${rpm.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color = status == "en panne" ? Colors.redAccent : (status == "maintenance" ? Colors.orangeAccent : Colors.greenAccent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(status?.toUpperCase() ?? "ACTIVE", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}