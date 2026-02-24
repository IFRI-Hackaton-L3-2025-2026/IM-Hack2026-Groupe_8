// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AlertsPage(),
//     );
//   }
// }

// enum AlertSeverity { critical, warning, info }

// class AlertItem {
//   final AlertSeverity severity;
//   final String timeAgo;
//   final String equipmentName;
//   final String description;
//   final String? prediction;
//   final double? aiConfidence;

//   const AlertItem({
//     required this.severity,
//     required this.timeAgo,
//     required this.equipmentName,
//     required this.description,
//     this.prediction,
//     this.aiConfidence,
//   });
// }

// class _AppColors {
//   static const background    = Color(0xFF0D1117);
//   static const card          = Color(0xFF161B22);
//   static const cardElevated  = Color(0xFF1C2333);
//   static const cyan          = Color(0xFF00E5FF);

//   static const criticalFg    = Color(0xFFFF6B35);
//   static const criticalBg    = Color(0xFF2A1A12);
//   static const criticalBr    = Color(0xFF8B3A2A);

//   static const warningFg     = Color(0xFFFFC107);
//   static const warningBg     = Color(0xFF2A2210);
//   static const warningBr     = Color(0xFF7A6020);

//   static const infoFg        = Color(0xFF26C6DA);
//   static const infoBg        = Color(0xFF0D2A30);
//   static const infoBr        = Color(0xFF1A5A65);
// class AlertsPage extends StatefulWidget {
//   const AlertsPage({super.key});

//   @override
//   State<AlertsPage> createState() => _AlertsPageState();
// }

// class _AlertsPageState extends State<AlertsPage> {
//   int _activeTab = 3;

//   const _alerts = [
//     AlertItem(
//       severity: AlertSeverity.critical,
//       timeAgo: '1d ago',
//       equipmentName: 'KUKA Robot KR-140',
//       description: 'Abnormal vibration detected in Joint 4',
//       prediction: 'Bearing failure predicted in 24-48 hours',
//       aiConfidence: 0.94,
//     ),
//     AlertItem(
//       severity: AlertSeverity.warning,
//       timeAgo: '1d ago',
//       equipmentName: 'CNC Machine XM-500',
//       description: 'Temperature threshold exceeded in axis motor',
//       prediction: 'Motor overheating risk within 72 hours',
//       aiConfidence: 0.78,
//     ),
//     AlertItem(
//       severity: AlertSeverity.info,
//       timeAgo: '2d ago',
//       equipmentName: 'Conveyor Belt CB-3',
//       description: 'Belt tension slightly below optimal range',
//     ),
//   ];

//   int _countBySeverity(AlertSeverity s) =>
//       _alerts.where((a) => a.severity == s).length;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _PageHeader(),
//                     const SizedBox(height: 20),
//                     _AlertSummaryCard(
//                       critical: _countBySeverity(AlertSeverity.critical),
//                       warning: _countBySeverity(AlertSeverity.warning),
//                       info: _countBySeverity(AlertSeverity.info),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       'Recent Alerts',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     ..._alerts.map(
//                       (a) => Padding(
//                         padding: const EdgeInsets.only(bottom: 14),
//                         child: _AlertCard(alert: a),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _BottomNavBar(
//               activeIndex: _activeTab,
//               onTap: (i) => setState(() => _activeTab = i),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PageHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Icon(Icons.notifications_outlined, color: _AppColors.cyan, size: 32),
//         const SizedBox(width: 12),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Predictive Alerts',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'AI-powered predictions using Random Forest & LSTM',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _AlertSummaryCard extends StatelessWidget {
//   final int critical;
//   final int warning;
//   final int info;

//   const _AlertSummaryCard({
//     required this.critical,
//     required this.warning,
//     required this.info,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _AppColors.card,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Alert Summary',
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: _SummaryBox(
//                   count: critical,
//                   label: 'Critical',
//                   fg: _AppColors.criticalFg,
//                   bg: _AppColors.criticalBg,
//                   border: _AppColors.criticalBr,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _SummaryBox(
//                   count: warning,
//                   label: 'Warning',
//                   fg: _AppColors.warningFg,
//                   bg: _AppColors.warningBg,
//                   border: _AppColors.warningBr,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _SummaryBox(
//                   count: info,
//                   label: 'Info',
//                   fg: _AppColors.infoFg,
//                   bg: _AppColors.infoBg,
//                   border: _AppColors.infoBr,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SummaryBox extends StatelessWidget {
//   final int count;
//   final String label;
//   final Color fg;
//   final Color bg;
//   final Color border;

//   const _SummaryBox({
//     required this.count,
//     required this.label,
//     required this.fg,
//     required this.bg,
//     required this.border,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: border),
//       ),
//       child: Column(
//         children: [
//           Text(
//             '$count',
//             style: TextStyle(color: fg, fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: TextStyle(color: fg, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AlertItem alert;

//   const _AlertCard({required this.alert});

//   Color get _fg => switch (alert.severity) {
//         AlertSeverity.critical => _AppColors.criticalFg,
//         AlertSeverity.warning  => _AppColors.warningFg,
//         AlertSeverity.info     => _AppColors.infoFg,
//       };

//   Color get _bg => switch (alert.severity) {
//         AlertSeverity.critical => _AppColors.criticalBg,
//         AlertSeverity.warning  => _AppColors.warningBg,
//         AlertSeverity.info     => _AppColors.infoBg,
//       };

//   Color get _br => switch (alert.severity) {
//         AlertSeverity.critical => _AppColors.criticalBr,
//         AlertSeverity.warning  => _AppColors.warningBr,
//         AlertSeverity.info     => _AppColors.infoBr,
//       };

//   IconData get _icon => alert.severity == AlertSeverity.info
//       ? Icons.info_outline
//       : Icons.error_outline;

//   String get _label {
//     final name = alert.severity.name;
//     return name[0].toUpperCase() + name.substring(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _AppColors.card,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: _bg,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: _fg.withOpacity(0.5), width: 1.5),
//                 ),
//                 child: Icon(_icon, color: _fg, size: 22),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: _fg, width: 1.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _label,
//                   style: TextStyle(color: _fg, fontSize: 11, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(alert.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             alert.equipmentName,
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: _AppColors.cardElevated,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               alert.description,
//               style: const TextStyle(color: Colors.white70, fontSize: 13),
//             ),
//           ),
//           if (alert.prediction != null) ...[
//             const SizedBox(height: 12),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.trending_up, color: _AppColors.cyan, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     alert.prediction!,
//                     style: const TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//           if (alert.aiConfidence != null) ...[
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Text('AI Confidence:', style: TextStyle(color: Colors.grey, fontSize: 12)),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(4),
//                     child: LinearProgressIndicator(
//                       value: alert.aiConfidence,
//                       minHeight: 6,
//                       backgroundColor: Colors.white10,
//                       valueColor: const AlwaysStoppedAnimation<Color>(_AppColors.cyan),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${(alert.aiConfidence! * 100).round()}%',
//                   style: const TextStyle(
//                     color: _AppColors.cyan,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _BottomNavBar extends StatelessWidget {
//   final int activeIndex;
//   final ValueChanged<int> onTap;

//   const _BottomNavBar({required this.activeIndex, required this.onTap});

//   static const _items = [
//     (icon: Icons.home_outlined,           label: 'Home'),
//     (icon: Icons.list_alt_outlined,       label: 'Equipment'),
//     (icon: Icons.history_outlined,        label: 'History'),
//     (icon: Icons.notifications_outlined,  label: 'Alerts'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: _AppColors.card,
//         border: Border(top: BorderSide(color: Colors.white12)),
//       ),
//       child: Row(
//         children: List.generate(_items.length, (i) {
//           final active = i == activeIndex;
//           final item   = _items[i];
//           return Expanded(
//             child: InkWell(
//               onTap: () => onTap(i),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(item.icon, color: active ? _AppColors.cyan : Colors.grey, size: 24),
//                     const SizedBox(height: 4),
//                     Text(
//                       item.label,
//                       style: TextStyle(
//                         color: active ? _AppColors.cyan : Colors.grey,
//                         fontSize: 11,
//                         fontWeight: active ? FontWeight.w600 : FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
