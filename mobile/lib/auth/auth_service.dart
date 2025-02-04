import 'dart:convert';
import 'package:farmers_market_swe/auth/AuthRequest.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'jwt_response.dart';

class AuthService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  AuthService({required this.baseUrl});

  Future<JwtResponse> login(AuthRequest request) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jwtResponse = JwtResponse.fromJson(jsonDecode(response.body));
      // Store token securely
      await _storage.write(key: 'accessToken', value: jwtResponse.accessToken);
      return jwtResponse;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'accessToken');
  }
}
