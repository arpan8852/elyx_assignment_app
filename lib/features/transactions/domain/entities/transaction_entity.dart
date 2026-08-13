// lib/features/transactions/domain/entities/transaction_entity.dart
import 'package:equatable/equatable.dart';

enum TransactionStatus { success, failed, pending }

class TransactionEntity extends Equatable {
  final String id;
  final String date;
  final double amount;
  final TransactionStatus status;
  final String merchant;
  final String description;

  const TransactionEntity({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.merchant,
    required this.description,
  });

  @override
  List<Object> get props => [id, date, amount, status, merchant, description];
}