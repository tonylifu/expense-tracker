import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  const ExpenseList({
    required this.expenses,
    required this.onRemoveExpense,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(
          expenses[index],
        ),
        child: ExpenseItem(
          expense: expenses[index],
        ),
        onDismissed: (direction) => onRemoveExpense(
          expenses[index],
        ),
        // confirmDismiss: (DismissDirection direction) async {
        //   final confirmed = await showDialog<bool>(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text('Are you sure you want to delete?'),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Navigator.pop(context, false),
        //             child: const Text('No'),
        //           ),
        //           TextButton(
        //             onPressed: () => Navigator.pop(context, true),
        //             child: const Text('Yes'),
        //           )
        //         ],
        //       );
        //     },
        //   );
        //   return confirmed;
        // },
      ),
      itemCount: expenses.length,
    );
  }
}
