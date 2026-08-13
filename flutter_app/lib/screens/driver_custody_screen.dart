name: lib/screens/driver_custody_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/driver_custody_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/custody_table.dart';
import '../widgets/custody_filters.dart';

class DriverCustodyScreen extends StatelessWidget {
  const DriverCustodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriverCustodyProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning alert
        if (!provider.loading && provider.countOutstandingOrOverdue > 0) ...[
          Card(
            color: Colors.orange.shade50,
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: Text('${provider.countOutstandingOrOverdue} drivers have outstanding or overdue custody'),
              trailing: TextButton(
                onPressed: () => provider.reviewCustody(),
                child: const Text('Review Custody'),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Summary cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SummaryCard(title: 'Total Active Custody', amount: provider.totalActiveCustody),
              const SizedBox(width: 12),
              SummaryCard(title: 'Total Collected', amount: provider.totalCollected),
              const SizedBox(width: 12),
              SummaryCard(title: 'Total Handed Over', amount: provider.totalHandedOver),
              const SizedBox(width: 12),
              SummaryCard(title: 'Outstanding Custody', amount: provider.outstandingCustody),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Filters
        CustodyFilters(),

        const SizedBox(height: 16),

        // Table title
        const Text('Driver Custody Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Table / states
        Expanded(
          child: Builder(builder: (context) {
            if (provider.loading) return const Center(child: CircularProgressIndicator());
            if (provider.error != null) return _ErrorView(error: provider.error!, onRetry: () => provider.load());
            if (provider.filtered.isEmpty) return const Center(child: Text('No driver custody data found.'));
            return CustodyTable(drivers: provider.filtered);
          }),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Error: $error', style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ]),
    );
  }
}
