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

  // Just for testing / debugging
  int get count => _expenses.length;
}