import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object> get props => [];
}

class FetchTransactionsEvent extends TransactionEvent {}

class RefreshTransactionsEvent extends TransactionEvent {}

class LoadMoreTransactionsEvent extends TransactionEvent {}
