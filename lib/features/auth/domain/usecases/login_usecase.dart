import 'package:elyx_assignment_app/core/errors/failures.dart';
import 'package:elyx_assignment_app/core/utils/either.dart';
import 'package:elyx_assignment_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, void>> call(String username, String password) async {
    
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return Left(
        value: ValidationFailure(
          message: 'Username and password cannot be empty',
        ),
      );
    }
    return await _repository.login(username, password);
  }
}
