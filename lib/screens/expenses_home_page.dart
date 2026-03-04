import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/navigation_utils.dart';
import 'add_expense_page.dart';

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<Expense> _expenses = [];

  double get _totalAmount =>
      _expenses.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> _openAddExpensePage() async {
    final Expense? expense = await pushAndAwaitResult<Expense>(
      context,
      const AddExpensePage(),
    );

    if (expense != null && mounted) {
      setState(() {
        _expenses.add(expense);
      });
      showSnackBar(context, 'Added: ${expense.title} — \$${expense.amount.toStringAsFixed(2)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // This the the line for the Total banner.
          if (_expenses.isNotEmpty)
            Container(
              width: double.infinity,
              color: colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total (${_expenses.length} item${_expenses.length == 1 ? '' : 's'})',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '₱${_totalAmount.toStringAsFixed(2)}',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

          // This is the code for the Expense list. 
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text('No expenses yet. Tap + to add one.', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      letterSpacing: -0.5,
                    ),),
                  )
                : ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(expense.title),
                        subtitle: Text(
                          '${expense.createdAt.day}/${expense.createdAt.month}/${expense.createdAt.year}',
                        ),
                        trailing: Text(
                          '₱${expense.amount.toStringAsFixed(2)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpensePage,
        icon: const Icon(Icons.add),
        label: const Text('Add Expenses'),
      ),
    );
  }
}