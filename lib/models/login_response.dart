class LoginResponse {
  final String status;
  final String? token;
  final dynamic error;
  final String? lang;

  const LoginResponse({
    required this.status,
    this.token,
    this.error,
    this.lang,
  });

}