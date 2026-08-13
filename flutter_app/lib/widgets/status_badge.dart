name: lib/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../models/driver_custody.dart';

class StatusBadge extends StatelessWidget {
  final CustodyStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (status) {
      case CustodyStatus.settled:
        color = Colors.green.shade600;
        text = 'Settled';
        break;
      case CustodyStatus.pending:
        color = Colors.amber.shade700;
        text = 'Pending';
        break;
      case CustodyStatus.overdue:
        color = Colors.red.shade600;
        text = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
