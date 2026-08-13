import 'package:elyx_assignment_app/core/errors/failures.dart';
import 'package:elyx_assignment_app/core/utils/either.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
}
