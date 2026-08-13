import 'package:elyx_assignment_app/core/network/api_service.dart';
import 'package:elyx_assignment_app/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions(int page);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiService _apiService;

  TransactionRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<TransactionModel>> getTransactions(int page) async {
    final response = await _apiService.getTransactions(page);
    return response.map((json) => TransactionModel.fromJson(json)).toList();
  }
}
