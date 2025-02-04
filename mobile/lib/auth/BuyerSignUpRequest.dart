import 'dart:convert';

class BuyerSignupRequest {
  final String username;
  final String email;
  final String password;
  final String name;
  final List<String> preferredDeliveryMethods;

  BuyerSignupRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.preferredDeliveryMethods,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'name': name,
      'preferredDeliveryMethods': preferredDeliveryMethods,
    };
  }
}
