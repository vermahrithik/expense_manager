import '../lib/services/expense_service.dart';

void main(List<String> arguments) async {
  final service = ExpenseService();
  await service.load();

  if (arguments.isEmpty) {
    printUsage();
    return;
  }

  final command = arguments[0].toLowerCase();

  switch (command) {
    case 'add':
      await handleAdd(service, arguments.skip(1).toList());
      break;
    case 'list':
      handleList(service);
      break;
    case 'delete':
      await handleDelete(service, arguments.skip(1).toList());
      break;
    case 'summary':
      handleSummary(service);
      break;
    default:
      print('Unknown command: $command');
      printUsage();
  }
}

void printUsage() {
  print('''
Expense Manager CLI

Usage:
  dart run bin/expense_manager.dart <command> [options]

Commands:
  add       Add a new expense
  list      List all expenses
  delete    Delete an expense by ID
  summary   Show total and count
''');
}

Future<void> handleAdd(ExpenseService service, List<String> args) async {
  double? amount;
  String? category;
  String note = '';

  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--amount' && i + 1 < args.length) {
      amount = double.tryParse(args[i + 1]);
    } else if (args[i] == '--category' && i + 1 < args.length) {
      category = args[i + 1];
    } else if (args[i] == '--note' && i + 1 < args.length) {
      note = args[i + 1];
    }
  }

  if (amount == null || category == null) {
    print('Error: --amount and --category are required');
    print('Example: add --amount 250 --category food --note "Dinner"');
    return;
  }

  final expense = await service.addExpense(
    amount: amount,
    category: category,
    note: note,
  );

  print('Added: $expense');
}

void handleList(ExpenseService service) {
  final expenses = service.getAllExpenses();

  if (expenses.isEmpty) {
    print('No expenses found.');
    return;
  }

  print('ID  | Amount   | Category     | Note');
  print('----|----------|--------------|----------------');

  for (final e in expenses) {
    print(
      '${e.id.toString().padRight(3)} | '
          '${e.amount.toStringAsFixed(2).padLeft(8)} | '
          '${e.category.padRight(12)} | '
          '${e.note}',
    );
  }
}

Future<void> handleDelete(ExpenseService service, List<String> args) async {
  if (args.isEmpty) {
    print('Error: Please provide an ID. Example: delete 2');
    return;
  }

  final id = int.tryParse(args[0]);
  if (id == null) {
    print('Error: ID must be a number');
    return;
  }

  final success = await service.deleteExpense(id);
  if (success) {
    print('Deleted expense with ID $id');
  } else {
    print('Expense with ID $id not found');
  }
}

void handleSummary(ExpenseService service) {
  final expenses = service.getAllExpenses();
  if (expenses.isEmpty) {
    print('No expenses yet.');
    return;
  }

  final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
  print('Total expenses : ${expenses.length}');
  print('Total amount   : ${total.toStringAsFixed(2)}');
}