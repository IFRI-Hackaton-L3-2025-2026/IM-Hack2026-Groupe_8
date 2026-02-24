import 'package:flutter/material.dart';
// A utilisé dans la homePage
class EquipmentCard extends StatelessWidget {
  final String name;
  final String type;
  final String line;
  final String status; // 'Active' ou 'Fault'

  const EquipmentCard({super.key,
    required this.name,
    required this.type,
    required this.line,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color textColor;

    switch (status) {
      case 'Active':
        statusColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;

      case 'Fault':
        statusColor = Colors.red.withOpacity(0.2);
        textColor = Colors.redAccent;
        break;

      case 'Maintenance':
        statusColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;

      default:
        statusColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2C), // Le bleu/noir très sombre de ta photo
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
          SizedBox(height: 4),
          Text("$type • $line", style: TextStyle(color: Colors.white54)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Le badge de statut
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              ),
              Text("KUKA", style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}