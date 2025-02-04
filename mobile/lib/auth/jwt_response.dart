class JwtResponse {
  final String accessToken;
  final String username;
  final List<String> roles;

  JwtResponse({
    required this.accessToken,
    required this.username,
    required this.roles,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      accessToken: json['accessToken'],
      username: json['username'],
      roles: List<String>.from(json['roles']),
    );
  }
}
