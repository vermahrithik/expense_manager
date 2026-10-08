import '../models/expense.dart';
import '../storage/expense_storage.dart';

class ExpenseService {
  final List<Expense> _expenses = [];
  int _nextId = 1;
  final ExpenseStorage _storage = ExpenseStorage();

  // Load data from file (call this once at startup)
  Future<void> load() async {
    final loaded = await _storage.load();
    _expenses.clear();
    _expenses.addAll(loaded);

    // Set nextId to be higher than any existing id
    if (_expenses.isNotEmpty) {
      _nextId = _expenses.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  // Save current list to file
  Future<void> save() async {
    await _storage.save(_expenses);
  }

  // Add a new expense
  Future<Expense> addExpense({
    required double amount,
    required String category,
    String note = '',
  }) async {
    final expense = Expense(
      id: _nextId++,
      amount: amount,
      category: category,
      note: note,
    );

    _expenses.add(expense);
    await save(); // auto-save
    return expense;
  }

  List<Expense> getAllExpenses() {
    return List.unmodifiable(_expenses);
  }

  Future<bool> deleteExpense(int id) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    _expenses.removeAt(index);
    await save();
    return true;
  }

  Future<Expense?> updateExpense(
      int id, {
        double? amount,
        String? category,
        String? note,
      }) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return null;

    final old = _expenses[index];
    final updated = old.copyWith(
      amount: amount,
      category: category,
      note: note,
    );

    _expenses[index] = updated;
    await save();
    return updated;
  }

  int get count => _expenses.length;
}