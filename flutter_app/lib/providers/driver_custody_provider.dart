name: lib/providers/driver_custody_provider.dart
import 'package:flutter/foundation.dart';
import '../models/driver_custody.dart';
import '../services/driver_custody_service.dart';

class DriverCustodyProvider extends ChangeNotifier {
  final DriverCustodyService _service = DriverCustodyService();

  List<DriverCustody> _all = [];
  List<DriverCustody> filtered = [];

  bool loading = false;
  String? error;

  // Filters
  String search = '';
  CustodyStatus? statusFilter;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool sortByHighestCustody = false;
  bool sortByOverdueFirst = false;

  // load
  Future<void> load({bool throwError = false}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      _all = await _service.fetchDriverCustodies(throwError: throwError);
      applyFilters();
    } catch (e) {
      error = e.toString();
      filtered = [];
      notifyListeners();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  double get totalActiveCustody => _all.fold(0.0, (p, e) => p + (e.currentCustody > 0 ? e.currentCustody : 0.0));
  double get totalCollected => _all.fold(0.0, (p, e) => p + e.collectedAmount);
  double get totalHandedOver => _all.fold(0.0, (p, e) => p + e.handedOverAmount);
  double get outstandingCustody => _all.fold(0.0, (p, e) => p + e.currentCustody);

  int get countOutstandingOrOverdue => _all.where((d) => d.currentCustody > 0 || d.status() == CustodyStatus.overdue).length;

  void applyFilters() {
    List<DriverCustody> list = List.from(_all);

    if (search.isNotEmpty) {
      list = list.where((d) => d.driverName.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (statusFilter != null) {
      list = list.where((d) => d.status() == statusFilter).toList();
    }

    if (dateFrom != null) {
      list = list.where((d) => d.lastSettlementDate.isAfter(dateFrom!) || d.lastSettlementDate.isAtSameMomentAs(dateFrom!)).toList();
    }
    if (dateTo != null) {
      list = list.where((d) => d.lastSettlementDate.isBefore(dateTo!) || d.lastSettlementDate.isAtSameMomentAs(dateTo!)).toList();
    }

    if (sortByHighestCustody) {
      list.sort((a, b) => b.currentCustody.compareTo(a.currentCustody));
    }

    if (sortByOverdueFirst) {
      list.sort((a, b) {
        final aOver = a.status() == CustodyStatus.overdue ? 0 : 1;
        final bOver = b.status() == CustodyStatus.overdue ? 0 : 1;
        return aOver.compareTo(bOver);
      });
    }

    filtered = list;
    notifyListeners();
  }

  void setSearch(String q) {
    search = q;
    applyFilters();
  }

  void setStatus(CustodyStatus? s) {
    statusFilter = s;
    applyFilters();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    dateFrom = from;
    dateTo = to;
    applyFilters();
  }

  void toggleSortHighest(bool v) {
    sortByHighestCustody = v;
    applyFilters();
  }

  void toggleSortOverdue(bool v) {
    sortByOverdueFirst = v;
    applyFilters();
  }

  void reviewCustody() {
    statusFilter = null;
    // filter to drivers with outstanding or overdue custody
    filtered = _all.where((d) => d.currentCustody > 0 || d.status() == CustodyStatus.overdue).toList();
    notifyListeners();
  }
}
