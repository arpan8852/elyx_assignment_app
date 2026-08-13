import 'dart:convert';

import 'package:elyx_assignment_app/core/errors/exceptions.dart';
import 'package:elyx_assignment_app/core/storage/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  final SecureStorageService secureStorageService;
  final void Function() onUnauthorized;

  ApiClient({
    http.Client? client,
    required this.secureStorageService,
    required this.onUnauthorized,
  }) : _client = client ?? http.Client();

  Future<Map<String, String>> _buildHeaders({bool requiresAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      final token = await secureStorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        try {
          return jsonDecode(response.body);
        } catch (_) {
          throw ParsingException(
            message: 'Invalid response format from server',
          );
        }
      case 401:
        onUnauthorized();
        throw UnauthorizedException(
          message: 'Session expired. Please login again.',
        );
      case 400:
        throw ServerException(
          message: _extractMessage(response.body, 'Invalid request'),
        );

      case 404:
        throw ServerException(message: 'Requested resource not found');

      case 500:
      case 502:
      case 503:
        throw ServerException(message: 'Server error. Please try again later.');
      default:
        throw ServerException(
          message: _extractMessage(
            response.body,
            'Something went wrong (${response.statusCode})',
          ),
        );
    }
  }

  String _extractMessage(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      return decoded['message'] ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(path).replace(
        queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
      );
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException(
        message: 'Request timed out. Please check your connection.',
      );
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        message: 'Network error. Please check your internet connection.',
      );
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(path);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException(
        message: 'Request timed out. Please check your connection.',
      );
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        message: 'Network error. Please check your internet connection.',
      );
    }
  }
}
