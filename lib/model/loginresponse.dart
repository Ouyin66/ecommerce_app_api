import 'user.dart';

class LoginResponse {
  final User? user;
  final String? message;
  final String? errorMessagePassword;
  final String? errorMessageEmail;

  LoginResponse(
      {this.user,
      this.message,
      this.errorMessagePassword,
      this.errorMessageEmail});
}
