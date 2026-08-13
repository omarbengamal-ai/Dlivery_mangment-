// flutter_app/lib/features/driver_financial_custody/models.dart
// نماذج بيانات لميزة Driver Financial Custody

class DriverSummary {
  String driverId;
  String name;
  String phone;
  double totalCollected;
  double outstanding;
  double settled;
  int deliveriesCount;

  DriverSummary({
    required this.driverId,
    required this.name,
    required this.phone,
    required this.totalCollected,
    required this.outstanding,
    required this.settled,
    required this.deliveriesCount,
  });
}

enum SettlementStatus { pending, processing, completed, failed }

class Settlement {
  final String id;
  final String driverId;
  final DateTime date;
  final double amount;
  final SettlementStatus status;
  final String? notes;

  Settlement({
    required this.id,
    required this.driverId,
    required this.date,
    required this.amount,
    required this.status,
    this.notes,
  });
}

class DriverTransaction {
  final String id;
  final String driverId;
  final DateTime date;
  final double amount;
  final String description;

  DriverTransaction({
    required this.id,
    required this.driverId,
    required this.date,
    required this.amount,
    required this.description,
  });
}
