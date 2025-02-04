import 'dart:convert';
import 'package:farmers_market_swe/auth/FarmerSignUpRequest.dart';
import 'package:http/http.dart' as http;

class FarmerSignupService {
  final String baseUrl;

  FarmerSignupService({required this.baseUrl});

  Future<String> signUp(FarmerSignupRequest request) async {
    final url = Uri.parse('$baseUrl/farmer/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body; 
    } else {
      throw Exception('Failed to register farmer: ${response.body}');
    }
  }
}
