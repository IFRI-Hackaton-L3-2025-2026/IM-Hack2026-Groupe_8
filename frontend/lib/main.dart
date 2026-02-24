// import 'package:flutter/material.dart';
// import 'package:frontend/screens/TimeMachinePage.dart';
// import 'package:frontend/screens/history_page.dart';
// import 'package:frontend/screens/equipment_page.dart';
// import 'package:frontend/screens/home_page.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int selectedIndex = 0;

//   final List<Widget> pages = const [
//     HomePage(),
//     EquipmentPage(),
//     PlaceholderPage(title: "History"),
//     PlaceholderPage(title: "Alerts"),
//   ];

//   void onItemTapped(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       title: 'BMI Demo',

//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//         ),
//       ),

//       // Page de démarrage
//       initialRoute: '/home_page',

//       //Les chemins
//       routes: {
//         '/home_page': (context) => const HomePage(),
//         '/equipment_page': (context) => const EquipmentPage(),
//         '/history_page': (context) =>  TimeMachinePage(),
//       },
//       home: Scaffold(
//         backgroundColor: const Color(0xFF0B1220),
//         body: pages[selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: selectedIndex,
//           onTap: onItemTapped,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: const Color(0xFF111827),
//           selectedItemColor: Colors.cyanAccent,
//           unselectedItemColor: Colors.white54,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.precision_manufacturing),
//               label: "Equipment",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.history),
//               label: "History",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.notifications),
//               label: "Alerts",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlaceholderPage extends StatelessWidget {
//   final String title;

//   const PlaceholderPage({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         title,
//         style: const TextStyle(color: Colors.white, fontSize: 22),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/controllers/AlertsController.dart';
import 'package:frontend/screens/MachineDetailPage.dart';
import 'package:frontend/screens/alerts_page.dart';
import 'package:get/get.dart'; 
import 'package:frontend/screens/TimeMachinePage.dart';
import 'package:frontend/screens/home_page.dart';

void main() {
  // On s'assure que GetX est prêt
  WidgetsFlutterBinding.ensureInitialized();
  
  // ON INITIALISE LE CONTROLLER ICI GLOBALEMENT
  Get.put(AlertsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // REMPLACEMENT de MaterialApp par GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maintenance Predictiv',
      
      theme: ThemeData(
        brightness: Brightness.dark, // Correspond mieux à ton design sombre
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Page de démarrage
      initialRoute: '/home_page',

      // REMPLACEMENT de routes par getPages (format GetX)
      getPages: [
        GetPage(name: '/home_page', page: () => const HomePage()),
        GetPage(name: '/history_page', page: () => TimeMachinePage()),
        GetPage(name: '/alerts_page', page: () =>  AlertsPage()),
        GetPage(name: '/machine_details', page: () => const EquipmentDetailPage()),
        // Ajoute ici tes autres pages si nécessaire
      ],
      
      // Note : On retire le "home: Scaffold" ici car GetX gère la navigation 
      // via les routes nommées définies ci-dessus.
    );
  }
}