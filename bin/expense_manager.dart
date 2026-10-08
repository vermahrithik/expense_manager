import '../lib/models/expense.dart';
import '../lib/services/expense_service.dart';

void main() {
  final service = ExpenseService();

  // Add some expenses
  service.addExpense(amount: 250, category: 'food', note: 'Dinner');
  service.addExpense(amount: 1200, category: 'transport', note: 'Train ticket');
  service.addExpense(amount: 80, category: 'food', note: 'Coffee');

  print('--- After Adding ---');
  for (final e in service.getAllExpenses()) {
    print(e);
  }

  // Update expense with id 2
  final updated = service.updateExpense(2, amount: 1350, note: 'Updated train ticket');
  print('\nUpdated: $updated');

  // Delete expense with id 3
  final deleted = service.deleteExpense(3);
  print('Deleted id 3? $deleted');

  print('\n--- Final List ---');
  for (final e in service.getAllExpenses()) {
    print(e);
  }

  print('\nTotal remaining: ${service.count}');
}