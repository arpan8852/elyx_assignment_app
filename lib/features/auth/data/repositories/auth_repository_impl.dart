import 'package:elyx_assignment_app/core/errors/exceptions.dart';
import 'package:elyx_assignment_app/core/errors/failures.dart';
import 'package:elyx_assignment_app/core/storage/secure_storage_service.dart';
import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:elyx_assignment_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDataSource,
    required SecureStorageService secureStorageService,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorageService = secureStorageService;

  @override
  Future<Either<Failure, void>> login(String username, String password) async {
    try {
      final response = await _remoteDataSource.login(username, password);
      await _secureStorageService.saveToken(response.token);
      return Right(value: null);
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
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _secureStorageService.hasToken();
  }

  @override
  Future<void> logout() async {
    await _secureStorageService.deleteToken();
  }
}
