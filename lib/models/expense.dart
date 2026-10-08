class Expense {
  final int id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.note = '',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Helper to create a copy with some fields changed (very useful later for update)
  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? note,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, category: $category, note: $note, date: $date)';
  }
}