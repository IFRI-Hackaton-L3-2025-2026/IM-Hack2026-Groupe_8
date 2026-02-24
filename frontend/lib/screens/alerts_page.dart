import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_bottom_bar.dart';
import '../services/api_service.dart'; // Import de ton service

// --- MODÈLES ---
enum AlertSeverity { critical, warning, info }

class AlertItem {
  final AlertSeverity severity;
  final String timeAgo;
  final String equipmentName;
  final String description;
  final String? prediction;
  final double? aiConfidence;

  const AlertItem({
    required this.severity,
    required this.timeAgo,
    required this.equipmentName,
    required this.description,
    this.prediction,
    this.aiConfidence,
  });
}

// --- COULEURS ---
class _AppColors {
  static const background    = Color(0xFF0D1117);
  static const card          = Color(0xFF161B22);
  static const cardElevated  = Color(0xFF1C2333);
  static const cyan          = Color(0xFF00E5FF);
  static const criticalFg    = Color(0xFFFF6B35);
  static const criticalBg    = Color(0xFF2A1A12);
  static const criticalBr    = Color(0xFF8B3A2A);
  static const warningFg     = Color(0xFFFFC107);
  static const warningBg     = Color(0xFF2A2210);
  static const warningBr     = Color(0xFF7A6020);
  static const infoFg        = Color(0xFF26C6DA);
  static const infoBg        = Color(0xFF0D2A30);
  static const infoBr        = Color(0xFF1A5A65);
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final int _currentIndex = 3;
  final ApiService api = ApiService();
  bool isLoading = true;
  List<AlertItem> _alerts = [];

  @override
  void initState() {
    super.initState();
    _fetchAlertData();
  }

  // Conversion des données API en AlertItem
  Future<void> _fetchAlertData() async {
    setState(() => isLoading = true);
    final data = await api.getAlerts();
    
    setState(() {
      _alerts = data.map((m) {
        bool isCritical = m['status'] == "en panne";
        return AlertItem(
          severity: isCritical ? AlertSeverity.critical : AlertSeverity.warning,
          timeAgo: 'Now', // L'API simule du temps réel
          equipmentName: m['name'] ?? 'Unknown Machine',
          description: isCritical 
            ? 'Critical Failure: Check temp (${m['temp_mean']}°C) and vibrations.' 
            : 'Warning: Abnormal sensor readings detected.',
          prediction: m['failure_next_24h'] == 1 
            ? 'Failure predicted within 24 hours' 
            : null,
          aiConfidence: m['failure_next_24h'] == 1 ? 0.85 : null,
        );
      }).toList();
      isLoading = false;
    });
  }

  void _onBottomTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0: Get.offAllNamed('/home_page'); break;
      case 1: Get.offNamed('/equipment_page'); break;
      case 2: Get.offNamed('/history_page'); break;
      case 3: break;
    }
  }

  int _countBySeverity(AlertSeverity s) => _alerts.where((a) => a.severity == s).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchAlertData,
          color: _AppColors.cyan,
          child: isLoading 
            ? const Center(child: CircularProgressIndicator(color: _AppColors.cyan))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _AlertSummaryCard(
                      critical: _countBySeverity(AlertSeverity.critical),
                      warning: _countBySeverity(AlertSeverity.warning),
                      info: _countBySeverity(AlertSeverity.info),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Live AI Alerts',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    if (_alerts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("All systems nominal. No alerts.", style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ..._alerts.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _AlertCard(alert: a),
                      )),
                  ],
                ),
              ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: _onBottomTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.psychology, color: _AppColors.cyan, size: 32),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Predictive Maintenance', 
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Connected to Flask AI Engine', 
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}


// --- SOUS-COMPOSANTS ---

class _AlertSummaryCard extends StatelessWidget {
  final int critical, warning, info;
  const _AlertSummaryCard({required this.critical, required this.warning, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alert Summary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Row(
            children: [
              _summaryBox(critical, 'Critical', _AppColors.criticalFg, _AppColors.criticalBg, _AppColors.criticalBr),
              const SizedBox(width: 8),
              _summaryBox(warning, 'Warning', _AppColors.warningFg, _AppColors.warningBg, _AppColors.warningBr),
              const SizedBox(width: 8),
              _summaryBox(info, 'Info', _AppColors.infoFg, _AppColors.infoBg, _AppColors.infoBr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(int count, String label, Color fg, Color bg, Color br) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: br)),
        child: Column(
          children: [
            Text('$count', style: TextStyle(color: fg, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: fg, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertItem alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final severityData = _getSeverityData();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: severityData.bg,
                child: Icon(severityData.icon, color: severityData.fg, size: 18),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: severityData.fg),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(alert.severity.name.toUpperCase(), 
                  style: TextStyle(color: severityData.fg, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Text(alert.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(alert.equipmentName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _AppColors.cardElevated, borderRadius: BorderRadius.circular(8)),
            child: Text(alert.description, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          if (alert.prediction != null) ...[
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.psychology, color: _AppColors.cyan, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(alert.prediction!, style: const TextStyle(color: _AppColors.cyan, fontSize: 12))),
            ]),
          ],
          if (alert.aiConfidence != null) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: alert.aiConfidence,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(_AppColors.cyan),
              minHeight: 4,
            ),
          ]
        ],
      ),
    );
  }

  ({Color fg, Color bg, IconData icon}) _getSeverityData() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return (fg: _AppColors.criticalFg, bg: _AppColors.criticalBg, icon: Icons.gpp_maybe);
      case AlertSeverity.warning:
        return (fg: _AppColors.warningFg, bg: _AppColors.warningBg, icon: Icons.warning_amber);
      case AlertSeverity.info:
        return (fg: _AppColors.infoFg, bg: _AppColors.infoBg, icon: Icons.info_outline);
    }
  }
}