import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/equipment_card.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/app_bottom_bar.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {

  final ApiService apiService = ApiService();

  /// navigation bottom bar
  int _currentIndex = 1;

  void _onBottomTap(int index) {
    if (index == _currentIndex) return;

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

  /// UI state
  String selectedFilter = "All";
  final TextEditingController searchController = TextEditingController();

  List<dynamic> equipments = [];
  bool isLoading = true;

  Timer? refreshTimer;

  
  // LOAD MACHINES FROM BACKEND
  
  Future<void> loadMachines() async {
    try {
      final data = await apiService.getMachines();

      if (!mounted) return;

      setState(() {
        equipments = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("API ERROR: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  
  // AUTO REFRESH (5s)
  
  void startAutoRefresh() {
    refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => loadMachines(),
    );
  }

  @override
  void initState() {
    super.initState();
    loadMachines();
    startAutoRefresh();
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  
  // STATUS MAPPING (BACKEND → UI)
  
  String normalizeStatus(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return "Active";
      case "warning":
        return "Maintenance";
      case "en panne":
        return "Fault";
      default:
        return "Active";
    }
  }

  @override
  Widget build(BuildContext context) {

    final filteredList = equipments.where((equipment) {

      final matchesFilter = selectedFilter == "All" ||
          equipment["brand"] == selectedFilter;

      final matchesSearch = equipment["name"]
          .toString()
          .toLowerCase()
          .contains(searchController.text.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 16),

              const Text(
                "Equipment Monitoring",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // SEARCH 
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search equipment...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= FILTERS =================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterButton("All"),
                    _filterButton("FANUC"),
                    _filterButton("SCHULER"),
                    _filterButton("SIEMENS"),
                    _filterButton("KUKA"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (isLoading)
                const Center(child: CircularProgressIndicator()),

              if (!isLoading)
                Text(
                  "${filteredList.length} equipment found",
                  style: const TextStyle(color: Colors.white70),
                ),

              const SizedBox(height: 8),

              //  LIST 
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {

                      final equipment = filteredList[index];

                      return EquipmentCard(
                        name: equipment["name"],
                        type: equipment["machine_type"],
                        line: equipment["brand"],
                        status: normalizeStatus(
                          equipment["status"],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: _onBottomTap,
      ),
    );
  }

  //  FILTER BUTTON 
  Widget _filterButton(String label) {

    final bool isSelected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.cyanAccent
                : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}