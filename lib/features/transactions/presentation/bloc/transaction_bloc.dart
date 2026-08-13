import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:elyx_assignment_app/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:elyx_assignment_app/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase _getTransactionsUseCase;
  int _currentPage = 1;
  static const int _pageSize = 10;

  TransactionBloc({required GetTransactionsUseCase getTransactionsUseCase})
    : _getTransactionsUseCase = getTransactionsUseCase,
      super(TransactionInitialState()) {
    on<FetchTransactionsEvent>(_onFetchTransactionsEvent);
    on<RefreshTransactionsEvent>(_onRefreshTransactionsEvent);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactionsEvent);
  }

  Future<void> _onFetchTransactionsEvent(
    FetchTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());
    _currentPage = 1;

    final result = await _getTransactionsUseCase(_currentPage);
    if (result is Left) {
      emit(TransactionErrorState(message: (result as Left).value.message));
      return;
    }

    final transactions = (result as Right).value;

    if (transactions.isEmpty) {
      emit(TransactionEmptyState());
    } else {
      emit(
        TransactionLoadedState(
          transactions: transactions,
          hasReachedMax: transactions.length < _pageSize,
        ),
      );
    }
  }

  Future<void> _onRefreshTransactionsEvent(
    RefreshTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionLoadedState) {
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(TransactionLoadingState());
    }
    _currentPage = 1;
    final result = await _getTransactionsUseCase(_currentPage);

    if (result is Left) {
      emit(TransactionErrorState(message: (result as Left).value.message));
      return;
    }

    final transactions = (result as Right).value;

    if (transactions.isEmpty) {
      emit(TransactionEmptyState());
    } else {
      emit(
        TransactionLoadedState(
          transactions: transactions,
          hasReachedMax: transactions.length < _pageSize,
          isRefreshing: false,
        ),
      );
    }
  }

  Future<void> _onLoadMoreTransactionsEvent(
    LoadMoreTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;

    if (currentState is! TransactionLoadedState ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }
    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final result = await _getTransactionsUseCase(nextPage);

    if (result is Left) {
      emit(currentState.copyWith(isLoadingMore: false));
      return;
    }

    final newTransactions = (result as Right).value;

    if (newTransactions.isEmpty) {
      emit(currentState.copyWith(isLoadingMore: false, hasReachedMax: true));
    } else {
      _currentPage = nextPage;
      emit(
        currentState.copyWith(
          transactions: [...currentState.transactions, ...newTransactions],
          hasReachedMax: newTransactions.length < _pageSize,
          isLoadingMore: false,
        ),
      );
    }
  }
}
