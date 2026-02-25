import 'package:flutter/material.dart';
// Widget a utilisé dans toute les pages pour la bottom bar



import 'package:get/get.dart';
import 'package:frontend/controllers/AlertsController.dart';

// --- WIDGET POUR L'ICÔNE QUI VIBRE ET CHANGE DE COULEUR ---
class AnimatedNavIcon extends StatefulWidget {
  final bool hasAlerts;
  final bool isSelected;
  const AnimatedNavIcon({super.key, required this.hasAlerts, required this.isSelected});

  @override
  State<AnimatedNavIcon> createState() => _AnimatedNavIconState();
}

class _AnimatedNavIconState extends State<AnimatedNavIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.white54,
      end: Colors.redAccent,
    ).animate(_controller);

    if (widget.hasAlerts) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedNavIcon oldWidget) {
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
        Color baseColor = widget.isSelected ? Colors.cyan : Colors.white54;
        
        return Transform.rotate(
          angle: widget.hasAlerts ? (_controller.value - 0.5) * 0.4 : 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.isSelected ? Icons.notifications : Icons.notifications_none,
                color: widget.hasAlerts ? _colorAnimation.value : baseColor,
                size: 26,
              ),
              if (widget.hasAlerts)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D1117), width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// --- BARRE DE NAVIGATION PRINCIPALE ---
class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Sécurité pour trouver ou créer le controller
    final alertCtrl = Get.isRegistered<AlertsController>() 
        ? Get.find<AlertsController>() 
        : Get.put(AlertsController());

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF0D1117),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.white54,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        // INDEX 0
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home, color: Colors.cyan),
          label: "Home",
        ), 
        // INDEX 1
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          activeIcon: Icon(Icons.access_time_filled, color: Colors.cyan),
          label: "History",
        ),
        // INDEX 2
        BottomNavigationBarItem(
          icon: Obx(() {
            bool hasAlerts = alertCtrl.riskyAlerts.any((m) => 
              m['status'] == "en panne" || m['status'] == "maintenance");

            return AnimatedNavIcon(
              hasAlerts: hasAlerts,
              isSelected: currentIndex == 2, // Index mis à jour à 2
            );
          }),
          label: "Alerts",
        ),
      ],
    );
  }
}