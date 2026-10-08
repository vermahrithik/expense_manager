# Expense Manager CLI

A clean, well-structured command-line Expense Manager built with Dart.

## Features

- Add, list, update, and delete expenses
- Persistent storage using JSON (`data/expenses.json`)
- Filter by category
- Search by note
- Filter by month
- Beautiful formatted table output
- Summary with total, average, and category breakdown
- Built with the official `args` package
- Unit tested

## Usage

```bash
# Add expense
dart run bin/expense_manager.dart add --amount 250 --category food --note "Dinner"

# List all expenses
dart run bin/expense_manager.dart list

# Filter by category
dart run bin/expense_manager.dart list --category food

# Search in notes
dart run bin/expense_manager.dart list --search lunch

# Filter by month (1-12)
dart run bin/expense_manager.dart list --month 10

# Update an expense
dart run bin/expense_manager.dart update 3 --amount 350 --note "Updated Lunch"

# Delete an expense
dart run bin/expense_manager.dart delete 2

# Show summary
dart run bin/expense_manager.dart summary

# Show help
dart run bin/expense_manager.dart help