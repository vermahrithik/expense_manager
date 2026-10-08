import '../models/expense.dart';

class ExpenseService {
  final List<Expense> _expenses = [];
  int _nextId = 1;

  // Add a new expense
  Expense addExpense({
    required double amount,
    required String category,
    String note = '',
  }) {
    final expense = Expense(
      id: _nextId++,
      amount: amount,
      category: category,
      note: note,
    );

    _expenses.add(expense);
    return expense;
  }

  // Get all expenses
  List<Expense> getAllExpenses() {
    return List.unmodifiable(_expenses); // return a copy so outside code can't modify our list
  }

  // Delete an expense by ID
  // Returns true if deleted, false if not found
  bool deleteExpense(int id) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) {
      return false; // not found
    }
    _expenses.removeAt(index);
    return true;
  }

// Update an existing expense
// Returns the updated expense, or null if not found
  Expense? updateExpense(
      int id, {
        double? amount,
        String? category,
        String? note,
      }) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) {
      return null; // not found
    }

    final old = _expenses[index];
    final updated = old.copyWith(
      amount: amount,
      category: category,
      note: note,
    );

    _expenses[index] = updated;
    return updated;
  }


  // Just for testing / debugging
  int get count => _expenses.length;
}