name: lib/widgets/driver_details_sheet.dart
import 'package:flutter/material.dart';
import '../models/driver_custody.dart';

class DriverDetailsSheet extends StatelessWidget {
  final DriverCustody driver;
  const DriverDetailsSheet({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, sc) => Container(
        padding: const EdgeInsets.all(16),
        child: ListView(controller: sc, children: [
          Text(driver.driverName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 12, children: [
            _statTile('Total Orders', driver.activeOrders.toString()),
            _statTile('Total Order Value', '\$${driver.totalOrdersValue.toStringAsFixed(2)}'),
            _statTile('Collected', '\$${driver.collectedAmount.toStringAsFixed(2)}'),
            _statTile('Handed Over', '\$${driver.handedOverAmount.toStringAsFixed(2)}'),
            _statTile('Current Custody', '\$${driver.currentCustody.toStringAsFixed(2)}'),
            _statTile('Last Settlement', _fmtDate(driver.lastSettlementDate)),
          ]),
          const SizedBox(height: 16),
          const Text('Settlement History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (driver.settlements.isEmpty) const Text('No previous settlements'),
          if (driver.settlements.isNotEmpty)
            ...driver.settlements.map((s) => ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text('\$${s.amount.toStringAsFixed(2)}'),
                  subtitle: Text(_fmtDate(s.date)),
                  trailing: Text(s.note),
                ))
        ]),
      ),
    );
  }

  Widget _statTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 220,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
