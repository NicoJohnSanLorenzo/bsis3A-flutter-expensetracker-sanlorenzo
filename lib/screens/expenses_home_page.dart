import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/navigation_utils.dart';
import '../widgets/expense_item.dart';
import 'add_expense_page.dart';

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<Expense> _expenses = [];
  
  double get _totalAmount => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> _openAddExpensePage() async {
    final Expense? expense = await pushAndAwaitResult<Expense>(
      context,
      const AddExpensePage(),
    );
    if (expense != null && mounted) {
      setState(() => _expenses.add(expense));
      showSnackBar(context, 'Added: ${expense.title} — ₱${expense.amount.toStringAsFixed(2)}');
    }
  }

  Future<void> _openEditExpensePage(int index) async {
    final Expense? updated = await pushAndAwaitResult<Expense>(
      context,
      AddExpensePage(existing: _expenses[index]),
    );
    if (updated != null && mounted) {
      setState(() => _expenses[index] = updated);
      showSnackBar(context, 'Updated: ${updated.title} — ₱${updated.amount.toStringAsFixed(2)}');
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
          // Total banner — hidden when list is empty
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
                    style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimaryContainer),
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

          // List or empty state
          Expanded(
            child: _expenses.isEmpty
                ? _EmptyState()         // Part C
                : _ExpenseList(         // Part B
                    expenses: _expenses,
                    onEdit: _openEditExpensePage,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpensePage,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}

// ── Part B — ListView.separated ──────────────────────────────────────────────

class _ExpenseList extends StatelessWidget {
  const _ExpenseList({required this.expenses, required this.onEdit});

  final List<Expense> expenses;
  final void Function(int index) onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: expenses.length,
      // Part A — reusable ExpenseItem widget
      itemBuilder: (context, index) => ExpenseItem(
        expense: expenses[index],
        onEdit: () => onEdit(index),
      ),
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 72,
        endIndent: 12,
      ),
    );
  }
}

// ── Part C — Empty state ──────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 72,
            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to add one',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
