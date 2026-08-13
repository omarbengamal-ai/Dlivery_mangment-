name: lib/widgets/custody_table.dart
import 'package:flutter/material.dart';
import '../models/driver_custody.dart';
import 'status_badge.dart';
import 'driver_details_sheet.dart';

class CustodyTable extends StatelessWidget {
  final List<DriverCustody> drivers;
  const CustodyTable({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Driver Name')),
          DataColumn(label: Text('Active Orders')),
          DataColumn(label: Text('Total Orders Value')),
          DataColumn(label: Text('Collected Amount')),
          DataColumn(label: Text('Handed Over')),
          DataColumn(label: Text('Current Custody')),
          DataColumn(label: Text('Last Settlement')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: drivers.map((d) {
          final status = d.status();
          return DataRow(cells: [
            DataCell(Text(d.driverName)),
            DataCell(Text(d.activeOrders.toString())),
            DataCell(Text('\$${d.totalOrdersValue.toStringAsFixed(2)}')),
            DataCell(Text('\$${d.collectedAmount.toStringAsFixed(2)}')),
            DataCell(Text('\$${d.handedOverAmount.toStringAsFixed(2)}')),
            DataCell(Text('\$${d.currentCustody.toStringAsFixed(2)}')),
            DataCell(Text('${_fmtDate(d.lastSettlementDate)}')),
            DataCell(StatusBadge(status: status)),
            DataCell(ElevatedButton(
              onPressed: () => _openDetails(context, d),
              child: const Text('View Details'),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _openDetails(BuildContext context, DriverCustody d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DriverDetailsSheet(driver: d),
    );
  }
}
