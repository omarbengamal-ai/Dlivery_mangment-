name: lib/models/driver_custody.dart
import 'package:flutter/foundation.dart';
import 'settlement.dart';

enum CustodyStatus { settled, pending, overdue }

class DriverCustody {
  final String driverId;
  final String driverName;
  final int activeOrders;
  final double totalOrdersValue;
  final double collectedAmount;
  final double handedOverAmount;
  final DateTime lastSettlementDate;
  final List<Settlement> settlements;

  DriverCustody({
    required this.driverId,
    required this.driverName,
    required this.activeOrders,
    required this.totalOrdersValue,
    required this.collectedAmount,
    required this.handedOverAmount,
    required this.lastSettlementDate,
    required this.settlements,
  });

  double get currentCustody => collectedAmount - handedOverAmount;

  CustodyStatus status({Duration overdueThreshold = const Duration(days: 30)}) {
    if (currentCustody <= 0) return CustodyStatus.settled;
    final overdue = DateTime.now().difference(lastSettlementDate) > overdueThreshold;
    return overdue ? CustodyStatus.overdue : CustodyStatus.pending;
  }
}
