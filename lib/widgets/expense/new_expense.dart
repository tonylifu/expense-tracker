import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  const NewExpense({required this.onAddExpense, super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory = Category.values.first;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: "GBP ",
                            label: Text("Amount"),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        icon: const Icon(Icons.arrow_downward),
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No Selected Date"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _showDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: "GBP ",
                            label: Text("Amount"),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No Selected Date"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _showDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => submitExpense(
                          _titleController.text,
                          double.tryParse(_amountController.text),
                          _selectedDate,
                          _selectedCategory,
                        ),
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        icon: const Icon(Icons.arrow_downward),
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => submitExpense(
                          _titleController.text,
                          double.tryParse(_amountController.text),
                          _selectedDate,
                          _selectedCategory,
                        ),
                        child: const Text("Save Expense"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void submitExpense(
    String title,
    double? amount,
    DateTime? dateTime,
    Category? category,
  ) {
    if (title.trim().isEmpty) {
      _showValidationMessage(
        context,
        "Title",
        "invalid title, you must provide a title input!",
      );
      return;
    }

    if (amount == null || amount.isNaN || amount <= 0) {
      _showValidationMessage(
        context,
        "Amount",
        "invalid amount, you must provide an amount greater than 0!",
      );
      return;
    }

    if (dateTime == null) {
      _showValidationMessage(
        context,
        "Date",
        "invalid date, you must select a valid date!",
      );
      return;
    }

    clearTextController();
    Navigator.of(context).pop();
    _saveExpense(
      title,
      amount,
      dateTime,
      category,
    );
  }

  void clearTextController() {
    _titleController.clear();
    _amountController.clear();
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(
      () {
        _selectedDate = pickedDate;
      },
    );
  }

  void _showValidationMessage(
      BuildContext context, String title, String alertMessage) {
    if (Platform.isIOS) {
      _showCupertinoValidationMessage(
          context: context, title: title, alertMessage: alertMessage);
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(alertMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  void _showCupertinoValidationMessage(
      {required BuildContext context,
      required String title,
      required String alertMessage}) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(alertMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  void _saveExpense(
    String title,
    double amount,
    DateTime dateTime,
    Category? category,
  ) {
    Expense expense = Expense(
      title: title,
      amount: amount,
      date: dateTime,
      category: category!,
    );
    widget.onAddExpense(expense);
  }
}
