// File: lib/models/transaction_model.dart

class TransactionModel {
  String id;
  DateTime date;
  String type; // 'debit' atau 'kredit'
  String description;
  double amount;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.amount,
  });
}