import 'package:elyx_assignment_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionErrorState extends TransactionState {
  final String message;
  const TransactionErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
class TransactionLoadedState extends TransactionState {
  final List<TransactionEntity> transactions;
  final bool hasReachedMax; 
  final bool isLoadingMore;  
  final bool isRefreshing; 

  const TransactionLoadedState({
    required this.transactions,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  TransactionLoadedState copyWith({
    List<TransactionEntity>? transactions,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return TransactionLoadedState(
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [transactions, hasReachedMax, isLoadingMore, isRefreshing];
}


class TransactionEmptyState extends TransactionState {}
