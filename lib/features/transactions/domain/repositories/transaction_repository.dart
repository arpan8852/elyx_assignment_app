import 'package:elyx_assignment_app/core/errors/failures.dart';
import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(int page);
}
