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

  // Convert Expense → Map (for JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  // Create Expense from Map (from JSON)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      note: json['note'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, category: $category, note: $note, date: $date)';
  }
}