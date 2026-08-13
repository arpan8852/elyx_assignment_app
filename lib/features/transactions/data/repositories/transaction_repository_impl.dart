// lib/features/transactions/data/repositories/transaction_repository_impl.dart
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
    int page,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactions(page);
      return Right(value: transactions);
    } on UnauthorizedException catch (e) {
      return Left(value: UnauthorizedFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(value: NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(value: TimeoutFailure(message: e.message));
    } on ParsingException catch (e) {
      return Left(value: ParsingFailure(message: e.message));
    } catch (e) {
      return Left(
        value: ServerFailure(
          message: 'Unable to fetch transactions. Please try again.',
        ),
      );
    }
  }
}
