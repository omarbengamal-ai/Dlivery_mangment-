name: lib/models/settlement.dart

class Settlement {
  final DateTime date;
  final double amount;
  final String note;

  Settlement({required this.date, required this.amount, this.note = ''});
}
