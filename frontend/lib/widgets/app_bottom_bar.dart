import 'package:flutter/material.dart';
// Widget a utilisé dans toute les pages pour la bottom bar
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      backgroundColor: const Color(0xFF0D1117),
      type: BottomNavigationBarType.fixed,
      elevation: 0,

      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.white54,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.precision_manufacturing),
          label: "Equipment",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Alerts",
        ),
      ],
    );
  }
}