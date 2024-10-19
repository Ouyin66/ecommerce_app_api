import 'user.dart';

class MessageResponse {
  final User? user;
  final String? errorMessage;
  final String? successMessage;
  final String? errorMessagePassword;
  final String? errorMessageEmail;

  MessageResponse(
      {this.user,
      this.successMessage,
      this.errorMessage,
      this.errorMessagePassword,
      this.errorMessageEmail});
}
