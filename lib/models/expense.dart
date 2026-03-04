class Expense {
  final String title;
   final double amount;
  final DateTime createdAt;

  Expense({
    required this.title,
    required this.amount,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}