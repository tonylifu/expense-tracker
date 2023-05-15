import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({
    required this.expenses,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: expenseBuilder,
      itemCount: expenses.length,
    );
  }

  Widget? expenseBuilder(BuildContext context, int index) {
    return ExpenseItem(
      expense: expenses[index],
    );
  }
}
