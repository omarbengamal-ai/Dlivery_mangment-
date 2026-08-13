name: lib/services/driver_custody_service.dart
import 'dart:async';
import '../models/driver_custody.dart';
import '../models/settlement.dart';

/// Mock service for driver custody data.
class DriverCustodyService {
  // Simulate network delay
  Future<List<DriverCustody>> fetchDriverCustodies({bool throwError = false}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (throwError) throw Exception('Failed to load driver custody data');

    final now = DateTime.now();
    List<DriverCustody> list = [
      DriverCustody(
        driverId: 'd1',
        driverName: 'Ali Hassan',
        activeOrders: 3,
        totalOrdersValue: 750.50,
        collectedAmount: 800.0,
        handedOverAmount: 500.0,
        lastSettlementDate: now.subtract(const Duration(days: 10)),
        settlements: [
          Settlement(date: now.subtract(const Duration(days: 40)), amount: 200.0, note: 'Monthly settlement'),
          Settlement(date: now.subtract(const Duration(days: 10)), amount: 500.0, note: 'Partial'),
        ],
      ),
      DriverCustody(
        driverId: 'd2',
        driverName: 'Fatima K.',
        activeOrders: 1,
        totalOrdersValue: 120.0,
        collectedAmount: 120.0,
        handedOverAmount: 120.0,
        lastSettlementDate: now.subtract(const Duration(days: 5)),
        settlements: [
          Settlement(date: now.subtract(const Duration(days: 5)), amount: 120.0),
        ],
      ),
      DriverCustody(
        driverId: 'd3',
        driverName: 'Omar Adel',
        activeOrders: 5,
        totalOrdersValue: 2400.0,
        collectedAmount: 2200.0,
        handedOverAmount: 1500.0,
        lastSettlementDate: now.subtract(const Duration(days: 60)),
        settlements: [
          Settlement(date: now.subtract(const Duration(days: 90)), amount: 1000.0),
          Settlement(date: now.subtract(const Duration(days: 60)), amount: 500.0),
        ],
      ),
      DriverCustody(
        driverId: 'd4',
        driverName: 'Sara Nasser',
        activeOrders: 0,
        totalOrdersValue: 0.0,
        collectedAmount: 0.0,
        handedOverAmount: 0.0,
        lastSettlementDate: now.subtract(const Duration(days: 1)),
        settlements: [],
      ),
      DriverCustody(
        driverId: 'd5',
        driverName: 'Mohamed Salah',
        activeOrders: 2,
        totalOrdersValue: 680.0,
        collectedAmount: 680.0,
        handedOverAmount: 200.0,
        lastSettlementDate: now.subtract(const Duration(days: 35)),
        settlements: [
          Settlement(date: now.subtract(const Duration(days: 35)), amount: 200.0),
        ],
      ),
    ];

    // Add some variability
    for (int i = 6; i <= 12; i++) {
      final daysAgo = (i * 7) % 50;
      list.add(DriverCustody(
        driverId: 'd$i',
        driverName: 'Driver $i',
        activeOrders: i % 4,
        totalOrdersValue: 100.0 * i,
        collectedAmount: 100.0 * i + 50.0,
        handedOverAmount: 50.0 * i,
        lastSettlementDate: now.subtract(Duration(days: daysAgo)),
        settlements: [
          Settlement(date: now.subtract(Duration(days: daysAgo + 10)), amount: 50.0 * i),
        ],
      ));
    }

    return list;
  }
}
