import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bottom_bar.dart';
import 'package:frontend/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ApiService api = ApiService();

  List machines = [];
  bool isLoading = true;
  bool isFetching = false;
  Timer? autoRefreshTimer;

  // Bottom bar
  int _currentIndex = 0;

  void _onBottomTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home_page');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/equipment_page');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/history_page');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/alerts');
    }
  }

  DateTime lastUpdated = DateTime.now();

  int totalActive = 0;
  int totalFault = 0;
  int totalMaintenance = 0;

  // Initialisation
  @override
  void initState() {
    super.initState();

    loadMachines();

    ///  Auto refresh toutes les 5 secondes
    autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        loadMachines();
      },
    );
  }

  /// Arrêter le timer
  @override
  void dispose() {
    autoRefreshTimer?.cancel();
    super.dispose();
  }

  // Rafraîchissement
  Future<void> refreshData() async {
    await loadMachines();
  }

  // Appel de l'API
  Future<void> loadMachines() async {

    if (isFetching) return;
    isFetching = true;

    try {
      final data = await api.getMachines();

      int active = 0;
      int fault = 0;
      int maintenance = 0;

      for (var m in data) {
        if (m['status'] == "active") active++;
        if (m['status'] == "en panne") fault++;
        if (m['status'] == "warning") maintenance++;
      }
      // 🛡️ ON VÉRIFIE SI LE WIDGET EST TOUJOURS LÀ
      if (!mounted) return;
      setState(() {
        machines = data;
        totalActive = active;
        totalFault = fault;
        totalMaintenance = maintenance;
        lastUpdated = DateTime.now();
        isLoading = false;
      });
      // 🛡️ AUSSI ICI POUR LE CATCH
    
    } catch (e) {
      debugPrint("Erreur API: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }

      // setState(() => isLoading = false);
    }

    isFetching = false;
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.cyanAccent,
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //header
                      const Row(
                        children: [
                          Icon(Icons.factory, color: Colors.cyanAccent),
                          SizedBox(width: 8),
                          Text(
                            "AI4BMI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Benin Moto Industry - Factory Overview",
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Last updated: ${lastUpdated.day}/${lastUpdated.month}/${lastUpdated.year} "
                        "${lastUpdated.hour}:${lastUpdated.minute.toString().padLeft(2, '0')}",
                        style:
                            const TextStyle(color: Colors.white38, fontSize: 12),
                      ),

                      const SizedBox(height: 20),

                      // Etat de l'industrie
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Factory Status",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statusItem(totalActive, "Active", Colors.green),
                                _statusItem(totalFault, "Fault", Colors.red),
                                _statusItem(
                                    totalMaintenance,
                                    "Maintenance",
                                    Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      //Machines du backend
                      if (machines.isEmpty)
                        const Center(
                          child: Text(
                            "No machines found",
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      else
                        ...machines.map((machine) {
                          return Column(
                            children: [
                              _machineSection(
                                machine['name'] ?? "Machine",
                                "${machine['units'] ?? 1} Units",
                                machine['active'] ?? 0,
                                machine['fault'] ?? 0,
                                machine['maintenance'] ?? 0,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
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

  Widget _statusItem(int count, String label, Color color) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _machineSection(
      String title, String units, int active, int fault, int maintenance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent),
                ),
                child: Text(
                  units,
                  style: const TextStyle(color: Colors.cyanAccent),
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _machineStatBox(active, "Active", Colors.green),
              const SizedBox(width: 8),
              _machineStatBox(fault, "Fault", Colors.red),
              const SizedBox(width: 8),
              _machineStatBox(maintenance, "Maintenance", Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _machineStatBox(int count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}