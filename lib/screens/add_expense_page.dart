import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../utils/navigation_utils.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _titleError;
  String? _amountError;

  void _onSave() {
    final String title = _titleController.text.trim();
    final String amountText = _amountController.text.trim();
    final double? amount = double.tryParse(amountText);

    setState(() {
      _titleError = title.isEmpty ? 'Expense title cannot be empty.' : null;
      _amountError = amountText.isEmpty
          ? 'Amount cannot be empty.'
          : amount == null || amount <= 0
              ? 'Enter a valid positive amount.'
              : null;
    });

    if (_titleError != null || _amountError != null) return;

    // The line that pops (or displays) the expense in the Home Screen.
    popWithResult<Expense>(
      context,
      Expense(title: title, amount: amount!),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Expense title',
                hintText: 'e.g. Coffee, Taxi, Groceries',
                errorText: _titleError,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'e.g. 12.50',
                errorText: _amountError,
                prefixText: '₱',
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (_) {
                if (_amountError != null) setState(() => _amountError = null);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onSave,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}