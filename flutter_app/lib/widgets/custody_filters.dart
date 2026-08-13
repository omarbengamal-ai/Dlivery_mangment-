name: lib/widgets/custody_filters.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/driver_custody.dart';
import '../providers/driver_custody_provider.dart';

class CustodyFilters extends StatefulWidget {
  @override
  State<CustodyFilters> createState() => _CustodyFiltersState();
}

class _CustodyFiltersState extends State<CustodyFilters> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriverCustodyProvider>(context);
    _searchCtrl.text = provider.search;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by driver name'),
                onChanged: (v) => provider.setSearch(v),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<CustodyStatus?>(
              value: provider.statusFilter,
              hint: const Text('Status'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: CustodyStatus.settled, child: Text('Settled')),
                DropdownMenuItem(value: CustodyStatus.pending, child: Text('Pending')),
                DropdownMenuItem(value: CustodyStatus.overdue, child: Text('Overdue')),
              ],
              onChanged: (v) => provider.setStatus(v),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (range != null) provider.setDateRange(range.start, range.end);
              },
              icon: const Icon(Icons.date_range),
              label: const Text('Date range'),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Sort by highest custody',
              child: IconButton(
                icon: Icon(provider.sortByHighestCustody ? Icons.arrow_downward : Icons.sort),
                onPressed: () => provider.toggleSortHighest(!provider.sortByHighestCustody),
              ),
            ),
            Tooltip(
              message: 'Sort overdue first',
              child: IconButton(
                icon: Icon(provider.sortByOverdueFirst ? Icons.priority_high : Icons.filter_alt),
                onPressed: () => provider.toggleSortOverdue(!provider.sortByOverdueFirst),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => provider.load(),
            ),
          ])
        ]),
      ),
    );
  }
}
