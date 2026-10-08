import 'package:expense_manager/services/expense_service.dart';

void main() async {
  final service = ExpenseService();

  // Load existing data
  await service.load();
  print('Loaded ${service.count} expenses from file');

  // Add a new one
  await service.addExpense(
    amount: 450,
    category: 'shopping',
    note: 'New shoes',
  );

  print('\n--- Current Expenses ---');
  for (final e in service.getAllExpenses()) {
    print(e);
  }

  print('\nData has been saved to data/expenses.json');
}