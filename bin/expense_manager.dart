import 'package:args/args.dart';
import '../lib/services/expense_service.dart';

void main(List<String> arguments) async {
  final service = ExpenseService();
  await service.load();

  final parser = ArgParser()
    ..addCommand('add')
    ..addCommand('list')
    ..addCommand('update')
    ..addCommand('delete')
    ..addCommand('summary')
    ..addCommand('help');

  // Add command options
  parser.commands['add']!
    ..addOption('amount', abbr: 'a', help: 'Amount of the expense')
    ..addOption('category', abbr: 'c', help: 'Category')
    ..addOption('note', abbr: 'n', help: 'Optional note');

  parser.commands['list']!
    ..addOption('category', abbr: 'c', help: 'Filter by category')
    ..addOption('search', abbr: 's', help: 'Search in note')
    ..addOption('month', abbr: 'm', help: 'Filter by month (1-12)');

  parser.commands['update']!
    ..addOption('amount', abbr: 'a')
    ..addOption('category', abbr: 'c')
    ..addOption('note', abbr: 'n');

  try {
    final results = parser.parse(arguments);

    if (results.command == null) {
      printUsage(parser);
      return;
    }

    switch (results.command!.name) {
      case 'add':
        await handleAdd(service, results.command!);
        break;
      case 'list':
        handleList(service, results.command!);
        break;
      case 'update':
        await handleUpdate(service, results.command!);
        break;
      case 'delete':
        await handleDelete(service, results.command!);
        break;
      case 'summary':
        handleSummary(service);
        break;
      case 'help':
        printUsage(parser);
        break;
      default:
        printUsage(parser);
    }
  } catch (e) {
    print('Error: $e');
    printUsage(parser);
  }
}

void printUsage(ArgParser parser) {
  print('''
Expense Manager CLI

Usage:
  dart run bin/expense_manager.dart <command> [options]

Commands:
  add       Add a new expense
  list      List expenses (supports filters)
  update    Update an expense
  delete    Delete an expense by ID
  summary   Show summary
  help      Show this help

Examples:
  add --amount 250 --category food --note "Dinner"
  list --category food
  list --search lunch
  list --month 10
  update 3 --amount 300
  delete 2
''');
}

Future<void> handleAdd(ExpenseService service, ArgResults args) async {
  final amountStr = args['amount'] as String?;
  final category = args['category'] as String?;
  final note = args['note'] as String? ?? '';

  if (amountStr == null || category == null) {
    print('Error: --amount and --category are required');
    return;
  }

  final amount = double.tryParse(amountStr);
  if (amount == null) {
    print('Error: amount must be a valid number');
    return;
  }

  final expense = await service.addExpense(
    amount: amount,
    category: category,
    note: note,
  );

  print('Added: $expense');
}

void handleList(ExpenseService service, ArgResults args) {
  var expenses = service.getAllExpenses();

  final categoryFilter = args['category'] as String?;
  final search = args['search'] as String?;
  final monthStr = args['month'] as String?;

  if (categoryFilter != null) {
    expenses = service.filterByCategory(categoryFilter);
  }

  if (search != null && search.isNotEmpty) {
    expenses = expenses
        .where((e) => e.note.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  if (monthStr != null) {
    final month = int.tryParse(monthStr);
    if (month != null && month >= 1 && month <= 12) {
      expenses = expenses.where((e) => e.date.month == month).toList();
    }
  }

  if (expenses.isEmpty) {
    print('No expenses found.');
    return;
  }

  // Table output
  print('┌──────┬────────────┬──────────────┬────────────────────────────┐');
  print('│  ID  │   Amount   │   Category   │            Note            │');
  print('├──────┼────────────┼──────────────┼────────────────────────────┤');

  for (final e in expenses) {
    final id = e.id.toString().padLeft(4);
    final amount = e.amount.toStringAsFixed(2).padLeft(10);
    final category = e.category.padRight(12);
    final note = (e.note.length > 26 ? '${e.note.substring(0, 23)}...' : e.note)
        .padRight(26);

    print('│ $id │ $amount │ $category │ $note │');
  }

  print('└──────┴────────────┴──────────────┴────────────────────────────┘');
}

Future<void> handleUpdate(ExpenseService service, ArgResults args) async {
  if (args.rest.isEmpty) {
    print('Error: Please provide an ID. Example: update 3 --amount 300');
    return;
  }

  final id = int.tryParse(args.rest[0]);
  if (id == null) {
    print('Error: ID must be a number');
    return;
  }

  final amountStr = args['amount'] as String?;
  final category = args['category'] as String?;
  final note = args['note'] as String?;

  double? amount;
  if (amountStr != null) {
    amount = double.tryParse(amountStr);
    if (amount == null) {
      print('Error: amount must be a valid number');
      return;
    }
  }

  if (amount == null && category == null && note == null) {
    print('Error: Provide at least one field to update');
    return;
  }

  final updated = await service.updateExpense(
    id,
    amount: amount,
    category: category,
    note: note,
  );

  if (updated != null) {
    print('Updated: $updated');
  } else {
    print('Expense with ID $id not found');
  }
}

Future<void> handleDelete(ExpenseService service, ArgResults args) async {
  if (args.rest.isEmpty) {
    print('Error: Please provide an ID. Example: delete 2');
    return;
  }

  final id = int.tryParse(args.rest[0]);
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
  final average = total / expenses.length;

  print('========== SUMMARY ==========');
  print('Total expenses : ${expenses.length}');
  print('Total amount   : ${total.toStringAsFixed(2)}');
  print('Average expense: ${average.toStringAsFixed(2)}');
  print('');

  final Map<String, double> byCategory = {};
  for (final e in expenses) {
    byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
  }

  print('--- By Category ---');
  final sorted = byCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final entry in sorted) {
    final percentage = (entry.value / total * 100).toStringAsFixed(1);
    print(
      '${entry.key.padRight(12)} : '
          '${entry.value.toStringAsFixed(2).padLeft(10)}  ($percentage%)',
    );
  }

  print('=============================');
}