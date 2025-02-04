import 'dart:convert';
import 'package:farmers_market_swe/auth/BuyerSignUpRequest.dart';
import 'package:http/http.dart' as http;

class BuyerSignupService {
  final String baseUrl;

  BuyerSignupService({required this.baseUrl});

  Future<String> signUp(BuyerSignupRequest request) async {
    final url = Uri.parse('$baseUrl/buyer/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body; // Success message from the backend
    } else {
      throw Exception('Failed to register buyer: ${response.body}');
    }
  }
}
