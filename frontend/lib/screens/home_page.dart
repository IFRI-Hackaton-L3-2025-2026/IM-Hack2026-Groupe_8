

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/app_bottom_bar.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/controllers/AlertsController.dart'; // Import important

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ApiService api = ApiService();
  
  List allMachines = [];
  List filteredMachines = [];
  String activeFilter = "All"; 
  
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
    
    // Initialisation du controller d'alertes s'il n'existe pas déjà
    if (!Get.isRegistered<AlertsController>()) {
      Get.put(AlertsController());
    }

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    loadMachines();
    
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) loadMachines();
    });
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
        } else if (status == "maintenance") {
          displayState = "maintenance";
          maintenance++;
        } else if (status == "warning") {
          displayState = "warning";
          active++; 
        } else {
          displayState = "healthy";
          active++;
        }

        return {
          ...m,
          'displayState': displayState,
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        allMachines = processed;
        totalActive = active;
        totalFault = fault;
        totalMaintenance = maintenance;
        _applyFilter(); 
        lastUpdated = DateTime.now();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur de chargement: $e");
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
                        ...filteredMachines.map((m) => _buildStatusCard(m)),
                    ],
                  ),
                ),
              ),
      ),
      // --- NAVIGATION MISE À JOUR (INDEX 0, 1, 2) ---
      bottomNavigationBar: AppBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return; // Déjà sur Home
          if (index == 1) Get.offNamed('/history_page');
          if (index == 2) Get.offNamed('/alerts_page');
        },
      ),
    );
  }

  Widget _buildStatusCard(Map m) {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        String state = m['displayState'];
        Color statusColor;
        String statusLabel;
        
        if (state == "dead") {
          statusColor = Colors.redAccent;
          statusLabel = "Failure";
        } else if (state == "maintenance") {
          statusColor = Colors.blueAccent;
          statusLabel = "Maintenance";
        } else if (state == "warning") {
          statusColor = Colors.orangeAccent;
          statusLabel = "Warning";
        } else {
          statusColor = Colors.greenAccent;
          statusLabel = "Healthy";
        }

        return GestureDetector(
          onTap: () => Get.toNamed('/machine_details', arguments: m),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state == "dead" 
                    ? statusColor.withOpacity(_blinkController.value) 
                    : Colors.white10,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['name'] ?? "Machine",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text("Robot • KUKA", style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const Text("KUKA", style: TextStyle(color: Colors.white10, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          _globalStat(totalMaintenance, "Maintenance", Colors.blueAccent),
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
      onSelected: (val) { if (val) { setState(() { activeFilter = label; _applyFilter(); }); } },
      selectedColor: color.withOpacity(0.3),
      backgroundColor: const Color(0xFF111827),
      labelStyle: TextStyle(color: isSelected ? color : Colors.white54, fontWeight: FontWeight.bold, fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? color : Colors.white10)),
    );
  }
}