// flutter_app/lib/features/driver_financial_custody/driver_financial_custody_service.dart
// خدمة وهمية (mock) لإمداد الـ UI بالبيانات — استبدلها لاحقاً بنداءات API حقيقية.

import 'dart:async';
import 'models.dart';

class DriverFinancialService {
  final Map<String, DriverSummary> _drivers = {
    'd1': DriverSummary(
      driverId: 'd1',
      name: 'Ali Hassan',
      phone: '+201234567890',
      totalCollected: 1200.0,
      outstanding: 300.0,
      settled: 900.0,
      deliveriesCount: 34,
    ),
    'd2': DriverSummary(
      driverId: 'd2',
      name: 'Sara Ahmed',
      phone: '+201098765432',
      totalCollected: 840.0,
      outstanding: 40.0,
      settled: 800.0,
      deliveriesCount: 21,
    ),
  };

  final Map<String, List<Settlement>> _settlements = {
    'd1': [
      Settlement(
          id: 's1',
          driverId: 'd1',
          date: DateTime.now().subtract(Duration(days: 60)),
          amount: 500.0,
          status: SettlementStatus.completed,
          notes: 'Monthly settlement'),
      Settlement(
          id: 's2',
          driverId: 'd1',
          date: DateTime.now().subtract(Duration(days: 10)),
          amount: 400.0,
          status: SettlementStatus.processing,
          notes: 'Bank transfer pending'),
    ],
    'd2': [
      Settlement(
          id: 's3',
          driverId: 'd2',
          date: DateTime.now().subtract(Duration(days: 30)),
          amount: 600.0,
          status: SettlementStatus.completed,
          notes: 'Settled via cash'),
    ],
  };

  final Map<String, List<DriverTransaction>> _transactions = {
    'd1': List.generate(
        10,
        (i) => DriverTransaction(
            id: 't${i + 1}',
            driverId: 'd1',
            date: DateTime.now().subtract(Duration(days: i * 2)),
            amount: (i % 2 == 0 ? 50.0 : -10.0),
            description: i % 2 == 0 ? 'Delivery COD' : 'Refund')),
    'd2': List.generate(
        6,
        (i) => DriverTransaction(
            id: 'u${i + 1}',
            driverId: 'd2',
            date: DateTime.now().subtract(Duration(days: i * 3)),
            amount: 40.0,
            description: 'Delivery COD')),
  };

  Future<List<DriverSummary>> listDrivers({String? search}) async {
    await Future.delayed(Duration(milliseconds: 200));
    var list = _drivers.values.toList();
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((d) => d.name.toLowerCase().contains(q) || d.phone.contains(q)).toList();
    }
    list.sort((a, b) => b.outstanding.compareTo(a.outstanding));
    return list;
  }

  Future<DriverSummary?> getDriver(String id) async {
    await Future.delayed(Duration(milliseconds: 120));
    return _drivers[id];
  }

  Future<List<Settlement>> listSettlements(String driverId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _settlements[driverId] ?? [];
  }

  Future<List<DriverTransaction>> listTransactions(String driverId, {DateTime? from, DateTime? to}) async {
    await Future.delayed(Duration(milliseconds: 200));
    final tx = _transactions[driverId] ?? [];
    if (from != null || to != null) {
      return tx.where((t) {
        final after = from == null || t.date.isAfter(from) || t.date.isAtSameMomentAs(from);
        final before = to == null || t.date.isBefore(to) || t.date.isAtSameMomentAs(to);
        return after && before;
      }).toList();
    }
    return tx;
  }

  Future<Settlement> createSettlement(String driverId, double amount, {String? notes}) async {
    await Future.delayed(Duration(milliseconds: 300));
    final id = 's${DateTime.now().millisecondsSinceEpoch}';
    final s = Settlement(id: id, driverId: driverId, date: DateTime.now(), amount: amount, status: SettlementStatus.pending, notes: notes);
    _settlements.putIfAbsent(driverId, () => []).insert(0, s);

    final summary = _drivers[driverId];
    if (summary != null) {
      // تعديل الحقول بطريقة بسيطة داخل mock
      summary.outstanding = (summary.outstanding - amount).clamp(0.0, double.infinity);
      summary.settled = summary.settled + amount;
    }
    return s;
  }

  Future<void> markSettlementCompleted(String settlementId, String driverId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final list = _settlements[driverId];
    if (list == null) return;
    final idx = list.indexWhere((s) => s.id == settlementId);
    if (idx >= 0) {
      final old = list[idx];
      list[idx] = Settlement(
        id: old.id,
        driverId: old.driverId,
        date: old.date,
        amount: old.amount,
        status: SettlementStatus.completed,
        notes: old.notes,
      );
    }
  }
}
