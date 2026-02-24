import 'package:flutter/material.dart';
import 'package:frontend/widgets/equipment_card.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  String selectedFilter = "All";
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> equipments = [
    {
      "name": "KUKA Robot KR-120",
      "type": "Robot",
      "line": "Assembly Line 1",
      "status": "Active",
      "brand": "KUKA"
    },
    {
      "name": "KUKA Robot KR-130",
      "type": "Robot",
      "line": "Assembly Line 2",
      "status": "Active",
      "brand": "KUKA"
    },
    {
      "name": "Fanuc Arm X-200",
      "type": "Robot",
      "line": "Assembly Line 3",
      "status": "Fault",
      "brand": "Fanuc"
    },
    {
      "name": "KUKA Robot KR-150",
      "type": "Robot",
      "line": "Assembly Line 4",
      "status": "Active",
      "brand": "KUKA"
    },
    {
      "name": "KUKA Robot KR-160",
      "type": "Robot",
      "line": "Assembly Line 5",
      "status": "Active",
      "brand": "KUKA"
    },
    {
      "name": "Fanuc CNC M-2000",
      "type": "CNC Machine",
      "line": "Machining Cell 1",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2100",
      "type": "CNC Machine",
      "line": "Machining Cell 1",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2200",
      "type": "CNC Machine",
      "line": "Machining Cell 1",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2300",
      "type": "CNC Machine",
      "line": "Machining Cell 2",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2400",
      "type": "CNC Machine",
      "line": "Machining Cell 2",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2500",
      "type": "CNC Machine",
      "line": "Machining Cell 2",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2600",
      "type": "CNC Machine",
      "line": "Machining Cell 3",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2700",
      "type": "CNC Machine",
      "line": "Machining Cell 3",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2800",
      "type": "CNC Machine",
      "line": "Machining Cell 3",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-2900",
      "type": "CNC Machine",
      "line": "Machining Cell 4",
      "status": "Active",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-3000",
      "type": "CNC Machine",
      "line": "Machining Cell 4",
      "status": "Maintenance",
      "brand": "Fanuc"
    },
    {
      "name": "Fanuc CNC M-3100",
      "type": "CNC Machine",
      "line": "Machining Cell 4",
      "status": "Maintenance",
      "brand": "Fanuc"
    },
    {
      "name": "Schuler Press SP-300",
      "type": "Press",
      "line": "Stamping Area 1",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-350",
      "type": "Press",
      "line": "Stamping Area 1",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-400",
      "type": "Press",
      "line": "Stamping Area 2",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-450",
      "type": "Press",
      "line": "Stamping Area 2",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-500",
      "type": "Press",
      "line": "Stamping Area 3",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-550",
      "type": "Press",
      "line": "Stamping Area 3",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-600",
      "type": "Press",
      "line": "Stamping Area 4",
      "status": "Active",
      "brand": "Schuler"
    },
    {
      "name": "Schuler Press SP-650",
      "type": "Press",
      "line": "Stamping Area 4",
      "status": "Maintenance",
      "brand": "Schuler"
    },

  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = equipments.where((equipment) {
      final matchesFilter =
          selectedFilter == "All" || equipment["brand"] == selectedFilter;

      final matchesSearch = equipment["name"]!
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
                    fontWeight: FontWeight.bold),
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

              // FILTERS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterButton("All"),
                    _filterButton("Fanuc"),
                    _filterButton("Schuler"),
                    _filterButton("Siemens"),
                    _filterButton("KUKA"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "${filteredList.length} equipment found",
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final equipment = filteredList[index];
                    return EquipmentCard(
                      name: equipment["name"]!,
                      type: equipment["type"]!,
                      line: equipment["line"]!,
                      status: equipment["status"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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