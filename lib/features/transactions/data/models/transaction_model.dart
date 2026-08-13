// lib/features/transactions/data/models/transaction_model.dart
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.date,
    required super.amount,
    required super.status,
    required super.merchant,
    required super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status'] as String?),
      merchant: json['merchant'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
    );
  }

  static TransactionStatus _parseStatus(String? status) {
    switch (status) {
      case 'SUCCESS':
        return TransactionStatus.success;
      case 'FAILED':
        return TransactionStatus.failed;
      case 'PENDING':
        return TransactionStatus.pending;
      default:
        return TransactionStatus.pending;
    }
  }
}