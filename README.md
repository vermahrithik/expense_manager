# Expense Manager CLI

A clean, well-structured command-line Expense Manager built with Dart.

## Features

- Add, list, update, and delete expenses
- Persistent storage using JSON (`data/expenses.json`)
- Filter expenses by category
- Summary with total + category breakdown
- Unit tested

## Usage

```bash
# Add expense
dart run bin/expense_manager.dart add --amount 250 --category food --note "Dinner"

# List all expenses
dart run bin/expense_manager.dart list

# List by category
dart run bin/expense_manager.dart list --category food

# Update an expense
dart run bin/expense_manager.dart update 3 --amount 350 --note "Updated Lunch"

# Delete an expense
dart run bin/expense_manager.dart delete 2

# Show summary
dart run bin/expense_manager.dart summary