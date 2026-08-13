// lib/core/network/mock_api_service.dart
import 'dart:math';
import '../errors/exceptions.dart';

/// Yeh class real backend ka role play karti hai.
/// ApiClient isko call karega jaise woh ek real server ho.
/// Isse structure exactly waisa hi rehta hai jaise real API
/// integration hoti - future me sirf yeh class replace karni hogi.
class ApiService {
  // In-memory fake transaction database (50 records)
  static final List<Map<String, dynamic>> _allTransactions = List.generate(50, (
    index,
  ) {
    final statuses = ['SUCCESS', 'FAILED', 'PENDING'];
    final merchants = ['Amazon', 'Swiggy', 'Netflix', 'Zomato', 'Flipkart'];
    return {
      "id": "TXN${1000 + index}",
      "date": "2026-0${(index % 9) + 1}-${(index % 28) + 1}",
      "amount": double.parse((Random().nextDouble() * 5000).toStringAsFixed(2)),
      "status": statuses[index % statuses.length],
      "merchant": merchants[index % merchants.length],
      "description": "Transaction for order #${5000 + index}",
    };
  });

  /// Mock login - real network delay simulate karta hai
  Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(
      const Duration(milliseconds: 900),
    ); // network delay simulate

    if (username == 'user' && password == 'pass') {
      return {"token": "abc.def.ghi"};
    } else {
      throw UnauthorizedException(message: 'Invalid username or password');
    }
  }

  /// Mock transactions list with pagination
  Future<List<Map<String, dynamic>>> getTransactions(int page) async {
    await Future.delayed(const Duration(milliseconds: 900));

    const pageSize = 10;
    final start = (page - 1) * pageSize;

    if (start >= _allTransactions.length) {
      return [];
    }

    final end = min(start + pageSize, _allTransactions.length);
    return _allTransactions.sublist(start, end);
  }
}
