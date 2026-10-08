import '../lib/models/expense.dart';

void main() {
  final expense = Expense(
    id: 1,
    amount: 250,
    category: 'food',
    note: 'Dinner',
  );

  print(expense);
  print('Amount: ${expense.amount}');
  print('Category: ${expense.category}');
}