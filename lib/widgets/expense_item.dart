import 'package:flutter/material.dart';
import '../models/expense.dart';

/// A reusable Card-based widget that displays a single [Expense].
///
/// Shows:
/// - title (via ListTile.title)
/// - formatted date, e.g. "Mar 12" (via ListTile.subtitle)
/// - amount in ₱ (via ListTile.trailing)
/// - an optional edit callback (pencil icon)
class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.expense,
    this.onEdit,
  });

  final Expense expense;

  /// Called when the user taps the edit icon. Pass null to hide the icon.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.receipt_long,
            color: colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          expense.title,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _formatDate(expense.createdAt),
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₱${expense.amount.toStringAsFixed(2)}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Edit expense',
                onPressed: onEdit,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Formats a [DateTime] to a short human-readable string, e.g. "Mar 12".
  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
