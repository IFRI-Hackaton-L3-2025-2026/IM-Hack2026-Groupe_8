import 'package:flutter/material.dart';
import 'package:frontend/screens/TimeMachinePage.dart';
import 'package:frontend/screens/history_page.dart';
import 'package:frontend/screens/equipment_page.dart';
import 'package:frontend/screens/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    EquipmentPage(),
    PlaceholderPage(title: "History"),
    PlaceholderPage(title: "Alerts"),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'BMI Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      // Page de démarrage
      initialRoute: '/home_page',

      //Les chemins
      routes: {
        '/home_page': (context) => const HomePage(),
        '/equipment_screen': (context) => const EquipmentPage(),
        '/history_page': (context) => const HistoryPage(),
      },
      home: Scaffold(
        backgroundColor: const Color(0xFF0B1220),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF111827),
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.precision_manufacturing),
              label: "Equipment",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Alerts",
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}