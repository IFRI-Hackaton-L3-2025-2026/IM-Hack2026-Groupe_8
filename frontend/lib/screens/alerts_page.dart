// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../widgets/app_bottom_bar.dart';
// import '../services/api_service.dart'; // Import de ton service

// // --- MODÈLES ---
// enum AlertSeverity { critical, warning, info }

// class AlertItem {
//   final AlertSeverity severity;
//   final String timeAgo;
//   final String equipmentName;
//   final String description;
//   final String? prediction;
//   final double? aiConfidence;

//   const AlertItem({
//     required this.severity,
//     required this.timeAgo,
//     required this.equipmentName,
//     required this.description,
//     this.prediction,
//     this.aiConfidence,
//   });
// }

// // --- COULEURS ---
// class _AppColors {
//   static const background    = Color(0xFF0D1117);
//   static const card          = Color(0xFF161B22);
//   static const cardElevated  = Color(0xFF1C2333);
//   static const cyan          = Color(0xFF00E5FF);
//   static const criticalFg    = Color(0xFFFF6B35);
//   static const criticalBg    = Color(0xFF2A1A12);
//   static const criticalBr    = Color(0xFF8B3A2A);
//   static const warningFg     = Color(0xFFFFC107);
//   static const warningBg     = Color(0xFF2A2210);
//   static const warningBr     = Color(0xFF7A6020);
//   static const infoFg        = Color(0xFF26C6DA);
//   static const infoBg        = Color(0xFF0D2A30);
//   static const infoBr        = Color(0xFF1A5A65);
// }

// class AlertsPage extends StatefulWidget {
//   const AlertsPage({super.key});

//   @override
//   State<AlertsPage> createState() => _AlertsPageState();
// }

// class _AlertsPageState extends State<AlertsPage> {
//   final int _currentIndex = 3;
//   final ApiService api = ApiService();
//   bool isLoading = true;
//   List<AlertItem> _alerts = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAlertData();
//   }

//   // Conversion des données API en AlertItem
//   Future<void> _fetchAlertData() async {
//     setState(() => isLoading = true);
//     final data = await api.getAlerts();
    
//     setState(() {
//       _alerts = data.map((m) {
//         bool isCritical = m['status'] == "en panne";
//         return AlertItem(
//           severity: isCritical ? AlertSeverity.critical : AlertSeverity.warning,
//           timeAgo: 'Now', // L'API simule du temps réel
//           equipmentName: m['name'] ?? 'Unknown Machine',
//           description: isCritical 
//             ? 'Critical Failure: Check temp (${m['temp_mean']}°C) and vibrations.' 
//             : 'Warning: Abnormal sensor readings detected.',
//           prediction: m['failure_next_24h'] == 1 
//             ? 'Failure predicted within 24 hours' 
//             : null,
//           aiConfidence: m['failure_next_24h'] == 1 ? 0.85 : null,
//         );
//       }).toList();
//       isLoading = false;
//     });
//   }

//   void _onBottomTap(int index) {
//     if (index == _currentIndex) return;
//     switch (index) {
//       case 0: Get.offAllNamed('/home_page'); break;
//       case 1: Get.offNamed('/equipment_page'); break;
//       case 2: Get.offNamed('/history_page'); break;
//       case 3: break;
//     }
//   }

//   int _countBySeverity(AlertSeverity s) => _alerts.where((a) => a.severity == s).length;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _AppColors.background,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _fetchAlertData,
//           color: _AppColors.cyan,
//           child: isLoading 
//             ? const Center(child: CircularProgressIndicator(color: _AppColors.cyan))
//             : SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 20),
//                     _AlertSummaryCard(
//                       critical: _countBySeverity(AlertSeverity.critical),
//                       warning: _countBySeverity(AlertSeverity.warning),
//                       info: _countBySeverity(AlertSeverity.info),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       'Live AI Alerts',
//                       style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 14),
//                     if (_alerts.isEmpty)
//                       const Center(
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 40),
//                           child: Text("All systems nominal. No alerts.", style: TextStyle(color: Colors.grey)),
//                         ),
//                       )
//                     else
//                       ..._alerts.map((a) => Padding(
//                         padding: const EdgeInsets.only(bottom: 14),
//                         child: _AlertCard(alert: a),
//                       )),
//                   ],
//                 ),
//               ),
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(
//         currentIndex: _currentIndex,
//         onTap: _onBottomTap,
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.psychology, color: _AppColors.cyan, size: 32),
//         const SizedBox(width: 12),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text('Predictive Maintenance', 
//               style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//             Text('Connected to Flask AI Engine', 
//               style: TextStyle(color: Colors.grey, fontSize: 12)),
//           ],
//         ),
//       ],
//     );
//   }
// }


// // --- SOUS-COMPOSANTS ---

// class _AlertSummaryCard extends StatelessWidget {
//   final int critical, warning, info;
//   const _AlertSummaryCard({required this.critical, required this.warning, required this.info});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: _AppColors.card, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Alert Summary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               _summaryBox(critical, 'Critical', _AppColors.criticalFg, _AppColors.criticalBg, _AppColors.criticalBr),
//               const SizedBox(width: 8),
//               _summaryBox(warning, 'Warning', _AppColors.warningFg, _AppColors.warningBg, _AppColors.warningBr),
//               const SizedBox(width: 8),
//               _summaryBox(info, 'Info', _AppColors.infoFg, _AppColors.infoBg, _AppColors.infoBr),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryBox(int count, String label, Color fg, Color bg, Color br) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: br)),
//         child: Column(
//           children: [
//             Text('$count', style: TextStyle(color: fg, fontSize: 24, fontWeight: FontWeight.bold)),
//             Text(label, style: TextStyle(color: fg, fontSize: 10)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AlertItem alert;
//   const _AlertCard({required this.alert});

//   @override
//   Widget build(BuildContext context) {
//     final severityData = _getSeverityData();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _AppColors.card,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 18,
//                 backgroundColor: severityData.bg,
//                 child: Icon(severityData.icon, color: severityData.fg, size: 18),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: severityData.fg),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(alert.severity.name.toUpperCase(), 
//                   style: TextStyle(color: severityData.fg, fontSize: 10, fontWeight: FontWeight.bold)),
//               ),
//               const Spacer(),
//               Text(alert.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 11)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(alert.equipmentName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(color: _AppColors.cardElevated, borderRadius: BorderRadius.circular(8)),
//             child: Text(alert.description, style: const TextStyle(color: Colors.white70, fontSize: 13)),
//           ),
//           if (alert.prediction != null) ...[
//             const SizedBox(height: 12),
//             Row(children: [
//               const Icon(Icons.psychology, color: _AppColors.cyan, size: 18),
//               const SizedBox(width: 8),
//               Expanded(child: Text(alert.prediction!, style: const TextStyle(color: _AppColors.cyan, fontSize: 12))),
//             ]),
//           ],
//           if (alert.aiConfidence != null) ...[
//             const SizedBox(height: 10),
//             LinearProgressIndicator(
//               value: alert.aiConfidence,
//               backgroundColor: Colors.white10,
//               valueColor: const AlwaysStoppedAnimation(_AppColors.cyan),
//               minHeight: 4,
//             ),
//           ]
//         ],
//       ),
//     );
//   }

//   ({Color fg, Color bg, IconData icon}) _getSeverityData() {
//     switch (alert.severity) {
//       case AlertSeverity.critical:
//         return (fg: _AppColors.criticalFg, bg: _AppColors.criticalBg, icon: Icons.gpp_maybe);
//       case AlertSeverity.warning:
//         return (fg: _AppColors.warningFg, bg: _AppColors.warningBg, icon: Icons.warning_amber);
//       case AlertSeverity.info:
//         return (fg: _AppColors.infoFg, bg: _AppColors.infoBg, icon: Icons.info_outline);
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:frontend/controllers/AlertsController.dart';
// import 'package:get/get.dart';
// import '../widgets/app_bottom_bar.dart';

// class AlertsPage extends StatelessWidget {
//   AlertsPage({super.key});

//   final controller = Get.put(AlertsController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => controller.fetchRiskyMachines(),
//           color: const Color(0xFF00E5FF),
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               // Header
//               SliverPadding(
//                 padding: const EdgeInsets.all(16),
//                 sliver: SliverToBoxAdapter(child: _buildHeader()),
//               ),
              
//               // Liste des alertes
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return const SliverFillRemaining(
//                     child: Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
//                   );
//                 }

//                 if (controller.riskyAlerts.isEmpty) {
//                   return const SliverFillRemaining(
//                     child: Center(
//                       child: Text("No critical alerts today", style: TextStyle(color: Colors.grey)),
//                     ),
//                   );
//                 }

//                 return SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final machine = controller.riskyAlerts[index];
//                         return _buildAlertCard(machine);
//                       },
//                       childCount: controller.riskyAlerts.length,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(
//         currentIndex: 3,
//         onTap: (index) {
//           if (index == 0) Get.offAllNamed('/home_page');
//           if (index == 1) Get.offNamed('/equipment_page');
//           if (index == 2) Get.offNamed('/history_page');
//         },
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.notifications_active_outlined, color: Color(0xFF00E5FF), size: 32),
//         const SizedBox(width: 12),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text('Alerts ', 
//               style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAlertCard(Map<String, dynamic> m) {
//     // Logique de Sévérité pour le design
//     bool isDown = m['status'] == "en panne";
//     bool isMaintenance = (m['maintenance_age_days'] ?? 0) > 100;
    
//     Color fg = isDown ? const Color(0xFFFF6B35) : (isMaintenance ? Colors.blueAccent : const Color(0xFFFFC107));
//     Color bg = fg.withOpacity(0.1);
//     IconData icon = isDown ? Icons.gpp_maybe : (isMaintenance ? Icons.settings : Icons.warning_amber);
//     String label = isDown ? "CRITICAL" : (isMaintenance ? "MAINTENANCE" : "HIGH RISK");

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF161B22),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: fg.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(radius: 14, backgroundColor: bg, child: Icon(icon, color: fg, size: 16)),
//                   const SizedBox(width: 10),
//                   Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               const Text("Now", style: TextStyle(color: Colors.grey, fontSize: 11)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(m['name'] ?? 'Unknown Robot', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//           const SizedBox(height: 6),
//           Text(
//             isDown ? "Machine has stopped. Urgent repair needed." : 
//             (isMaintenance ? "Scheduled maintenance age limit reached." : "AI predicts a failure within the next 24 hours."),
//             style: const TextStyle(color: Colors.white70, fontSize: 13),
//           ),
          
//           // AI Confidence Bar (uniquement si ce n'est pas encore en panne)
//           if (!isDown) ...[
//             const SizedBox(height: 14),
//             Row(
//               children: [
//                 const Icon(Icons.analytics, color: Color(0xFF00E5FF), size: 14),
//                 const SizedBox(width: 5),
//                 const Text("AI Confidence", style: TextStyle(color: Color(0xFF00E5FF), fontSize: 11)),
//                 const Spacer(),
//                 Text("${(0.85 * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 11)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             LinearProgressIndicator(
//               value: 0.85,
//               backgroundColor: Colors.white10,
//               valueColor: const AlwaysStoppedAnimation(Color(0xFF00E5FF)),
//               minHeight: 3,
//             ),
//           ]
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:frontend/controllers/AlertsController.dart';
// import 'package:get/get.dart';
// import '../widgets/app_bottom_bar.dart';

// class AlertsPage extends StatelessWidget {
//   AlertsPage({super.key});

//   final controller = Get.put(AlertsController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => controller.fetchRiskyMachines(),
//           color: const Color(0xFF00E5FF),
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               // Header avec le point de notification
//               SliverPadding(
//                 padding: const EdgeInsets.all(16),
//                 sliver: SliverToBoxAdapter(
//                   child: Obx(() => _buildHeader(controller.riskyAlerts.isNotEmpty)),
//                 ),
//               ),
              
//               // Liste des alertes filtrées
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return const SliverFillRemaining(
//                     child: Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
//                   );
//                 }

//                 // --- FILTRAGE : Uniquement Failure et Maintenance provenant du serveur ---
//                 final filteredList = controller.riskyAlerts.where((m) {
//                   return m['status'] == "en panne" || m['status'] == "maintenance";
//                 }).toList();

//                 if (filteredList.isEmpty) {
//                   return const SliverFillRemaining(
//                     child: Center(
//                       child: Text("No active alerts", style: TextStyle(color: Colors.grey)),
//                     ),
//                   );
//                 }

//                 return SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) => _buildAlertCard(filteredList[index]),
//                       childCount: filteredList.length,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: AppBottomBar(
//         currentIndex: 3,
//         onTap: (index) {
//           if (index == 0) Get.offAllNamed('/home_page');
//           if (index == 1) Get.offNamed('/equipment_page');
//           if (index == 2) Get.offNamed('/history_page');
//         },
//       ),
//     );
//   }

//   // Header avec un point rouge si des alertes existent
//   Widget _buildHeader(bool hasAlerts) {
//     return Row(
//       children: [
//         Stack(
//           children: [
//             const Icon(Icons.notifications_active_outlined, color: Color(0xFF00E5FF), size: 35),
//             if (hasAlerts)
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(width: 12),
//         const Text(
//           'Alerts', 
//           style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildAlertCard(Map<String, dynamic> m) {
//     bool isFailure = m['status'] == "en panne";
    
//     Color fg = isFailure ? const Color(0xFFFF6B35) : Colors.blueAccent;
//     Color bg = fg.withOpacity(0.1);
//     IconData icon = isFailure ? Icons.report_problem : Icons.build_circle;
//     String label = isFailure ? "FAILURE" : "MAINTENANCE";

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF161B22),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: fg.withOpacity(0.4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(radius: 14, backgroundColor: bg, child: Icon(icon, color: fg, size: 16)),
//                   const SizedBox(width: 10),
//                   Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               const Text("Now", style: TextStyle(color: Colors.grey, fontSize: 11)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             m['name'] ?? 'Robot Unit', 
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             isFailure 
//               ? "System has stopped due to a critical failure." 
//               : "This unit is currently under maintenance.",
//             style: const TextStyle(color: Colors.white70, fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:frontend/controllers/AlertsController.dart';
import 'package:get/get.dart';
import '../widgets/app_bottom_bar.dart';

// --- WIDGET D'ICÔNE VIBRANTE (Header) ---
class VibratingAlertIcon extends StatefulWidget {
  final bool hasAlerts;
  const VibratingAlertIcon({super.key, required this.hasAlerts});

  @override
  State<VibratingAlertIcon> createState() => _VibratingAlertIconState();
}

class _VibratingAlertIconState extends State<VibratingAlertIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.hasAlerts) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VibratingAlertIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasAlerts && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.hasAlerts) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.hasAlerts ? (_controller.value - 0.5) * 0.3 : 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_active_outlined, 
                         color: Color(0xFF00E5FF), size: 35),
              if (widget.hasAlerts)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red, 
                      shape: BoxShape.circle
                    ),
                    constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// --- PAGE PRINCIPALE ---
class AlertsPage extends StatelessWidget {
  AlertsPage({super.key});

  // Utilisation de find ou put selon si le controller existe déjà
  final controller = Get.isRegistered<AlertsController>() 
      ? Get.find<AlertsController>() 
      : Get.put(AlertsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchRiskyMachines(),
          color: const Color(0xFF00E5FF),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header avec Animation
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Obx(() => VibratingAlertIcon(
                        hasAlerts: controller.riskyAlerts.any((m) => 
                          m['status'] == "en panne" || m['status'] == "maintenance")
                      )),
                      const SizedBox(width: 12),
                      const Text(
                        'Alerts', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 32, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Liste des alertes
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
                  );
                }

                final filteredList = controller.riskyAlerts.where((m) {
                  return m['status'] == "en panne" || m['status'] == "maintenance";
                }).toList();

                if (filteredList.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("No critical issues detected", 
                           style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAlertCard(filteredList[index]),
                      childCount: filteredList.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      // --- NAVIGATION CORRIGÉE ---
      bottomNavigationBar: AppBottomBar(
        currentIndex: 2, // L'index des Alerts est maintenant 2
        onTap: (index) {
          if (index == 0) Get.offAllNamed('/home_page');
          if (index == 1) Get.offNamed('/history_page');
          if (index == 2) return; // Déjà sur Alerts
        },
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> m) {
    bool isFailure = m['status'] == "en panne";
    
    Color fg = isFailure ? const Color(0xFFFF6B35) : Colors.blueAccent;
    Color bg = fg.withOpacity(0.1);
    IconData icon = isFailure ? Icons.report_problem_rounded : Icons.build_circle_rounded;
    String label = isFailure ? "FAILURE" : "MAINTENANCE";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14, 
                    backgroundColor: bg, 
                    child: Icon(icon, color: fg, size: 16)
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label, 
                    style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              const Text("Now", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            m['name'] ?? 'Robot Unit', 
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 18
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFailure 
              ? "Critical: Machine has stopped. Manual intervention required." 
              : "System performing scheduled maintenance protocols.",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}