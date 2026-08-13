// flutter_app/lib/features/driver_financial_custody/widgets/driver_summary_card.dart

import 'package:flutter/material.dart';
import '../models.dart';

class DriverSummaryCard extends StatelessWidget {
  final DriverSummary summary;
  final VoidCallback? onTap;

  const DriverSummaryCard({Key? key, required this.summary, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(summary.name),
        subtitle: Text('${summary.phone} • ${summary.deliveriesCount} deliveries'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Outstanding', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            SizedBox(height: 4),
            Text('${summary.outstanding.toStringAsFixed(2)} EGP', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
