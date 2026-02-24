import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/app_bottom_bar.dart';
import 'package:frontend/controllers/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController controller = Get.put(HistoryController());
  final int _currentIndex = 2;

  void _onBottomTap(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home_page');
    } else if (index == 1) Navigator.pushReplacementNamed(context, '/equipment_page');
    else if (index == 2) Navigator.pushReplacementNamed(context, '/history_page');
    else if (index == 3) Navigator.pushReplacementNamed(context, '/alerts');
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) controller.selectedDate.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.cyan, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Time Machine',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text('Explore historical telemetry data', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),
              _buildDateSelector(),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.cyan));
                  }
                  if (controller.errorMessage.value != null) {
                    return Center(child: Text(controller.errorMessage.value!, style: const TextStyle(color: Colors.red)));
                  }
                  if (!controller.showData.value) {
                    return _buildPlaceholder();
                  }
                  return _buildTelemetryChart();
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentIndex: _currentIndex, onTap: _onBottomTap),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Obx(() => _buildInputBox(
              Icons.calendar_today,
              "${controller.selectedDate.value.day.toString().padLeft(2, '0')}/"
              "${controller.selectedDate.value.month.toString().padLeft(2, '0')}/"
              "${controller.selectedDate.value.year}",
              _pickDate)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.loadTelemetryData,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Load Historical Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(12)),
      child: const Text('Select a date to explore historical data', style: TextStyle(color: Colors.grey)),
    );
  }
// Graphe
  Widget _buildTelemetryChart() {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 25, left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 40, bottom: 10),
            child: Text(
              "Historical Telemetry Data",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() => LineChart(
              LineChartData(
                minX: 0,
                maxX: 24,
                minY: controller.minY,
                maxY: controller.maxY,
                
                // Points interactifs  (heure + vitesse + temps)
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: const Color(0xFF1C2128),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.spotIndex;
                        if (index >= controller.rawDataList.length) return null;
                        
                        final data = controller.rawDataList[index];
                        final rpm = data["rpm_mean"] ?? 0.0;
                        
                        // Conversion de X (decimal) en HH:mm
                        int hour = spot.x.toInt();
                        int minute = ((spot.x - hour) * 60).toInt();
                        String timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

                        return LineTooltipItem(
                          '$timeStr\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'Temp: ${spot.y.toStringAsFixed(1)}°C\n',
                              style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: 'Vitesse: ${rpm.toStringAsFixed(0)} RPM',
                              style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),

                // Graphe en papier millimétré
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5, 
                  verticalInterval: 1,   
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.08),
                    strokeWidth: 0.5,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.08),
                    strokeWidth: 0.5,
                  ),
                ),
                
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white10, width: 1),
                ),

                // Titres des axes
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(
                      "Température (°C)",
                      style: TextStyle(color: Colors.cyan, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    axisNameSize: 22,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text('${value.toInt()}°', style: const TextStyle(color: Colors.grey, fontSize: 9)),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      "Heure (24h)",
                      style: TextStyle(color: Colors.cyan, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    axisNameSize: 22,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4, 
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 5,
                        child: Text('${value.toInt()}h', style: const TextStyle(color: Colors.grey, fontSize: 9)),
                      ),
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: Colors.cyan,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.cyan.withOpacity(0.2),
                          Colors.cyan.withOpacity(0.0),
                        ],
                      ),
                    ),
                    spots: controller.telemetryData.toList(),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox(IconData icon, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 10),
            Text(value, style: const TextStyle(color: Colors.white)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}