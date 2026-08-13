import 'package:elyx_assignment_app/core/network/api_service.dart';
import 'package:elyx_assignment_app/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required ApiService mockApiService})
    : apiService = mockApiService;
  @override
  Future<LoginResponseModel> login(String username, String password) async {
   final response = await apiService.login(username, password);
   print("rtykmnb $response");
   return LoginResponseModel.fromJson(response);
  }
}
