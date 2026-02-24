import 'package:flutter/material.dart';
import 'package:frontend/controllers/MachineDetailsController.Dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Pour les jauges de température/RPM
import 'package:fl_chart/fl_chart.dart'; // Pour le monitoring des vibrations

class EquipmentDetailPage extends StatelessWidget {
   const EquipmentDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Le controller récupère les données passées lors de la navigation
    final MachineDetailsController controller = Get.put(MachineDetailsController());
    // Structure de données basée sur ton API Flask (get_one_machine)
    // On accède aux infos statiques et aux données dynamiques
    final Map<dynamic, dynamic> m = controller.machine;
    final info = m['info'] ?? {};
    final current = m['current'] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          info['name'] ?? "Machine Detail",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          _buildStatusChip(current['status']),
          const SizedBox(width: 15),
        ],
      ),
      body: Obx(() {
        // Obx permet de rafraîchir la page si le controller met à jour 'machine'
        final dynamicData = controller.machine['current'] ?? {};
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION INFOS GÉNÉRALES ---
              _buildTopInfoSection(info, dynamicData),
              const SizedBox(height: 25),
              
              const Text(
                "Real-Time Sensors",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 15),

              // --- VIBRATION MONITOR (Utilise history_db) ---
              _buildSensorCard(
                title: "Vibration Monitor",
                subtitle: "IMU/VTX100",
                value: "${dynamicData['vib_mean'] ?? 0} mm/s",
                icon: Icons.vibration,
                color: Colors.cyanAccent,
                child: _buildWaveChart(Colors.cyanAccent, controller.getVibrationSpots()),
              ),

              // --- TEMPERATURE SENSOR (temp_mean) ---
              _buildSensorCard(
                title: "Temperature Sensor",
                subtitle: "OMEGA-CX-MINI",
                value: "${dynamicData['temp_mean'] ?? 0}°C",
                icon: Icons.thermostat,
                color: Colors.orangeAccent,
                child: _buildTempGauge(dynamicData['temp_mean']?.toDouble() ?? 0.0),
              ),

              // --- ROTARY ENCODER (rpm_mean) ---
              _buildSensorCard(
                title: "Rotary Encoder",
                subtitle: "RPN-1500",
                value: "${dynamicData['rpm_mean'] ?? 0} RPM",
                icon: Icons.autorenew,
                color: Colors.greenAccent,
                child: _buildRpmGauge(dynamicData['rpm_mean']?.toDouble() ?? 0.0),
              ),

              // --- OIL QUALITY (oil_particle_count) ---
              _buildSensorCard(
                title: "Oil Quality Sensor",
                subtitle: "ICM 2.0",
                value: "${dynamicData['oil_particle_count'] ?? 0}%",
                icon: Icons.opacity,
                color: Colors.cyanAccent,
                child: _buildOilLevel((dynamicData['oil_particle_count'] ?? 0) / 100),
              ),
            ],
          ),
        );
      }),
      
    );
    
  }

  // --- WIDGETS DE STRUCTURE ---

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

  Widget _buildSensorCard({
    required String title, 
    required String subtitle, 
    required String value, 
    required IconData icon, 
    required Color color, 
    required Widget child
  }) {
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

  // --- GRAPHIQUES ET JAUGES ---

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
              MarkerPointer(value: temp, markerType: MarkerType.circle, color: Colors.white, markerHeight: 10, markerWidth: 10)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRpmGauge(double rpm) {
    return SizedBox(
      height: 120,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0, maximum: 2000, showLabels: false, showTicks: false,
            axisLineStyle: const AxisLineStyle(thickness: 6, color: Colors.white10),
            pointers: <GaugePointer>[
              RangePointer(value: rpm, width: 6, color: Colors.greenAccent, cornerStyle: CornerStyle.bothCurve),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  "${rpm.toInt()}\nRPM", 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
                )
              )
            ]
          )
        ],
      ),
    );
  }

  Widget _buildOilLevel(double percent) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent, 
            backgroundColor: Colors.white10, 
            color: Colors.cyanAccent, 
            minHeight: 6
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Condition", style: TextStyle(color: Colors.white38, fontSize: 10)),
            Text(
              percent > 0.7 ? "EXCELLENT" : "WEAR DETECTED", 
              style: TextStyle(color: percent > 0.7 ? Colors.greenAccent : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String? status) {
    bool isError = status == "en panne";
    bool isWarning = status == "warning";
    Color color = isError ? Colors.redAccent : (isWarning ? Colors.orangeAccent : Colors.greenAccent);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5))
      ),
      child: Center(
        child: Text(
          status?.toUpperCase() ?? "ACTIVE", 
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)
        )
      ),
    );
  }
}