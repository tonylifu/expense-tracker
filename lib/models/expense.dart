import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  leisure,
  work,
  study,
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
  Category.study: Icons.computer,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.category({required allExpense, required this.category})
      : expenses = allExpense
            .where(
              (expense) => expense.category == category,
            )
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }

  double getTotalExpensesByCategory(Category category) {
    double sum = 0;
    for (final expense in expenses) {
      if (expense.category == category) {
        sum += expense.amount;
      }
    }
    return sum;
  }
}
