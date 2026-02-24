import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/app_bottom_bar.dart';
import 'package:frontend/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ApiService api = ApiService();
  
  List allMachines = [];
  List filteredMachines = [];
  String activeFilter = "All"; // Filtre par défaut
  
  bool isLoading = true;
  bool isFetching = false;
  late AnimationController _blinkController;
  DateTime lastUpdated = DateTime.now();

  int totalActive = 0;
  int totalFault = 0;
  int totalMaintenance = 0;

  @override
  void initState() {
    super.initState();
    // Animation de clignotement pour les machines "Dead"
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    loadMachines();
    Timer.periodic(const Duration(seconds: 5), (timer) => loadMachines());
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> loadMachines() async {
    if (isFetching) return;
    isFetching = true;
    try {
      final data = await api.getMachines();
      
      int active = 0;
      int fault = 0;
      int maintenance = 0;

      List processed = data.map((m) {
        String status = m['status'] ?? "active";
        String displayState = "healthy"; 

        if (status == "en panne") {
          displayState = "dead";
          fault++;
        } else if (status == "warning") {
          // Différenciation Maintenance (Bleu) vs Warning (Orange)
          bool isUnderMaintenance = (m['maintenance_age_days'] ?? 0) > 100;
          displayState = isUnderMaintenance ? "maintenance" : "warning";
          isUnderMaintenance ? maintenance++ : active++;
        } else {
          active++;
        }

        return {
          ...m,
          'displayState': displayState,
          'activeCount': (status == "active") ? 1 : 0,
          'faultCount': (status == "en panne") ? 1 : 0,
          'warningCount': (status == "warning") ? 1 : 0,
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        allMachines = processed;
        totalActive = active;
        totalFault = fault;
        totalMaintenance = maintenance;
        _applyFilter(); // Réappliquer le filtre après chargement
        lastUpdated = DateTime.now();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur : $e");
    } finally {
      isFetching = false;
    }
  }

  void _applyFilter() {
    setState(() {
      if (activeFilter == "All") {
        filteredMachines = allMachines;
      } else if (activeFilter == "Failure") {
        filteredMachines = allMachines.where((m) => m['displayState'] == "dead").toList();
      } else if (activeFilter == "Maintenance") {
        filteredMachines = allMachines.where((m) => m['displayState'] == "maintenance").toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
            : RefreshIndicator(
                onRefresh: loadMachines,
                color: Colors.cyanAccent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildFactoryStatusCard(),
                      const SizedBox(height: 25),
                      
                      // --- SECTION FILTRE ---
                      const Text("Filter by Status", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      _buildFilterRow(),
                      
                      const SizedBox(height: 20),
                      Text(
                        "$activeFilter Machines (${filteredMachines.length})",
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      
                      if (filteredMachines.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: Text("No machines match this filter", style: TextStyle(color: Colors.white38))),
                        )
                      else
                        ...filteredMachines.map((m) => _buildAnimatedMachineCard(m)),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Get.offNamed('/equipment_page');
          if (index == 2) Get.offNamed('/history_page');
          if (index == 3) Get.offNamed('/alerts_page');
        },
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        _filterChip("All", Colors.cyanAccent),
        const SizedBox(width: 8),
        _filterChip("Failure", Colors.redAccent),
        const SizedBox(width: 8),
        _filterChip("Maintenance", Colors.blueAccent),
      ],
    );
  }

  Widget _filterChip(String label, Color color) {
    bool isSelected = activeFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          activeFilter = label;
          _applyFilter();
        }
      },
      selectedColor: color.withOpacity(0.3),
      backgroundColor: const Color(0xFF111827),
      labelStyle: TextStyle(color: isSelected ? color : Colors.white54, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? color : Colors.white10),
      ),
    );
  }

  Widget _buildAnimatedMachineCard(Map m) {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        String state = m['displayState'];
        Color borderColor;
        double borderWidth = 1.0;
        
        if (state == "dead") {
          borderColor = Colors.redAccent.withOpacity(_blinkController.value);
          borderWidth = 2.0;
        } else if (state == "maintenance") {
          borderColor = Colors.blueAccent;
          borderWidth = 1.5;
        } else if (state == "warning") {
          borderColor = Colors.orangeAccent;
        } else {
          borderColor = Colors.greenAccent.withOpacity(0.4);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m['name'] ?? "Machine", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    _getStatusIcon(state),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _miniBox(m['activeCount'], "Active", Colors.green),
                    const SizedBox(width: 8),
                    _miniBox(m['faultCount'], "Failure", Colors.red),
                    const SizedBox(width: 8),
                    _miniBox(m['warningCount'], "Warning", Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getStatusIcon(String state) {
    if (state == "dead") return const Icon(Icons.flash_on, color: Colors.redAccent, size: 20);
    if (state == "maintenance") return const Icon(Icons.settings, color: Colors.blueAccent, size: 20);
    if (state == "warning") return const Icon(Icons.warning, color: Colors.orangeAccent, size: 20);
    return const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20);
  }

  Widget _miniBox(int count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text("$count", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AI4BMI Dashboard", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Updated: ${lastUpdated.hour}:${lastUpdated.minute.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.white38)),
          ],
        ),
        const CircleAvatar(backgroundColor: Color(0xFF1F2937), child: Icon(Icons.person, color: Colors.cyanAccent)),
      ],
    );
  }

  Widget _buildFactoryStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _globalStat(totalActive, "Operational", Colors.greenAccent),
          _globalStat(totalFault, "Down", Colors.redAccent),
          _globalStat(totalMaintenance, "Service", Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _globalStat(int val, String lab, Color col) {
    return Column(
      children: [
        Text("$val", style: TextStyle(color: col, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(lab, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}