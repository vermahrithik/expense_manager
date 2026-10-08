import 'dart:convert';
import 'dart:io';
import '../models/expense.dart';

class ExpenseStorage {
  final String filePath;

  ExpenseStorage({this.filePath = 'data/expenses.json'});

  // Load expenses from file
  Future<List<Expense>> load() async {
    final file = File(filePath);

    if (!await file.exists()) {
      return []; // file doesn't exist yet → return empty list
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(content);
    return jsonList
        .map((json) => Expense.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Save expenses to file
  Future<void> save(List<Expense> expenses) async {
    final file = File(filePath);

    // Make sure the data/ folder exists
    await file.parent.create(recursive: true);

    final jsonList = expenses.map((e) => e.toJson()).toList();
    final content = jsonEncode(jsonList);

    await file.writeAsString(content);
  }
}