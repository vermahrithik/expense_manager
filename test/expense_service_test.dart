import 'package:test/test.dart';
import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/services/expense_service.dart';

void main() {
  group('Expense Model', () {
    test('toJson and fromJson work correctly', () {
      final original = Expense(
        id: 1,
        amount: 250.5,
        category: 'food',
        note: 'Dinner',
        date: DateTime(2026, 10, 9, 14, 30),
      );

      final json = original.toJson();
      final restored = Expense.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.amount, equals(original.amount));
      expect(restored.category, equals(original.category));
      expect(restored.note, equals(original.note));
      expect(restored.date, equals(original.date));
    });

    test('copyWith works', () {
      final original = Expense(
        id: 1,
        amount: 100,
        category: 'food',
        note: 'Old note',
      );

      final updated = original.copyWith(amount: 200, note: 'New note');

      expect(updated.id, equals(1));
      expect(updated.amount, equals(200));
      expect(updated.category, equals('food'));
      expect(updated.note, equals('New note'));
    });
  });

  group('ExpenseService', () {
    late ExpenseService service;

    setUp(() async {
      service = ExpenseService();
      // We don't call load() here so we start with empty list every test
    });

    test('addExpense increases count and assigns id', () async {
      final expense = await service.addExpense(
        amount: 100,
        category: 'food',
        note: 'Test',
      );

      expect(service.count, equals(1));
      expect(expense.id, equals(1));
      expect(expense.amount, equals(100));
      expect(expense.category, equals('food'));
    });

    test('deleteExpense removes the correct item', () async {
      await service.addExpense(amount: 100, category: 'food');
      await service.addExpense(amount: 200, category: 'transport');

      final deleted = await service.deleteExpense(1);

      expect(deleted, isTrue);
      expect(service.count, equals(1));
      expect(service.getAllExpenses().first.id, equals(2));
    });

    test('deleteExpense returns false for non-existing id', () async {
      final deleted = await service.deleteExpense(999);
      expect(deleted, isFalse);
    });

    test('updateExpense changes the correct fields', () async {
      await service.addExpense(amount: 100, category: 'food', note: 'Old');

      final updated = await service.updateExpense(
        1,
        amount: 150,
        note: 'Updated',
      );

      expect(updated, isNotNull);
      expect(updated!.amount, equals(150));
      expect(updated.note, equals('Updated'));
      expect(updated.category, equals('food')); // unchanged
    });
  });

  group('ExpenseService Filtering', () {
    late ExpenseService service;

    setUp(() async {
      service = ExpenseService();
      await service.addExpense(amount: 100, category: 'food', note: 'Lunch');
      await service.addExpense(amount: 200, category: 'transport', note: 'Train');
      await service.addExpense(amount: 50, category: 'food', note: 'Coffee');
    });

    test('filterByCategory works', () {
      final result = service.filterByCategory('food');
      expect(result.length, equals(2));
      expect(result.every((e) => e.category == 'food'), isTrue);
    });

    test('searchByNote works', () {
      final result = service.searchByNote('coffee');
      expect(result.length, equals(1));
      expect(result.first.note, equals('Coffee'));
    });

    test('filterByMonth works', () {
      final result = service.filterByMonth(DateTime.now().month);
      expect(result.length, equals(3)); // all added today
    });
  });
}