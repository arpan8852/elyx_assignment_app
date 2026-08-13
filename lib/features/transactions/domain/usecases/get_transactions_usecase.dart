import 'package:elyx_assignment_app/core/errors/failures.dart';
import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:elyx_assignment_app/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository _repository;

  GetTransactionsUseCase({required TransactionRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<TransactionEntity>>> call(int page) async {
    return await _repository.getTransactions(page);
  }
}
