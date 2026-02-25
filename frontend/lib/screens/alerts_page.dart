


import 'package:flutter/material.dart';
import 'package:frontend/controllers/AlertsController.dart';
import 'package:get/get.dart';
import '../widgets/app_bottom_bar.dart';

// --- WIDGET D'ICÔNE VIBRANTE ---
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
    if (widget.hasAlerts) _controller.repeat(reverse: true);
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
                  right: -2, top: -2,
                  child: Container(
                    width: 12, height: 12,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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

  final controller = Get.isRegistered<AlertsController>() 
      ? Get.find<AlertsController>() 
      : Get.put(AlertsController());

  // Fonction utilitaire pour nettoyer et comparer les statuts de l'API
  bool _isCriticalStatus(String? status) {
    if (status == null) return false;
    final s = status.toLowerCase().trim();
    // On vérifie "en panne" mais aussi "warning" car ton Python en génère aussi !
    return s.contains("panne") || s == "maintenance" || s == "warning";
  }

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
              // Header
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Obx(() => VibratingAlertIcon(
                        hasAlerts: controller.riskyAlerts.any((m) => _isCriticalStatus(m['status'])),
                      )),
                      const SizedBox(width: 12),
                      const Text('Alerts', 
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              
              // Liste des alertes avec Obx
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
                  );
                }

                // FILTRAGE CORRIGÉ ICI
                final filteredList = controller.riskyAlerts.where((m) {
                  return _isCriticalStatus(m['status']);
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
      bottomNavigationBar: AppBottomBar(
        currentIndex: 2, 
        onTap: (index) {
          if (index == 0) Get.offAllNamed('/home_page');
          if (index == 1) Get.offNamed('/history_page');
        },
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> m) {
    final status = (m['status'] ?? "").toString().toLowerCase();
    bool isFailure = status.contains("panne");
    bool isWarning = status == "warning";
    
    // Couleurs adaptatives
    Color fg = isFailure ? const Color(0xFFFF6B35) : (isWarning ? Colors.amber : Colors.blueAccent);
    Color bg = fg.withOpacity(0.1);
    IconData icon = isFailure ? Icons.report_problem_rounded : (isWarning ? Icons.warning_amber_rounded : Icons.build_circle_rounded);
    String label = isFailure ? "FAILURE" : (isWarning ? "WARNING" : "MAINTENANCE");

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
                  CircleAvatar(radius: 14, backgroundColor: bg, child: Icon(icon, color: fg, size: 16)),
                  const SizedBox(width: 10),
                  Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text("Now", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(m['name'] ?? 'Robot Unit', 
               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            isFailure ? "Critical: Machine has stopped. Manual intervention required." : 
            isWarning ? "Abnormal behavior detected. Check sensors immediately." :
            "System performing scheduled maintenance protocols.",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}