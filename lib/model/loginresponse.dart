import 'location.dart';
import 'product.dart';
import 'cart.dart';
import 'user.dart';
import 'variant.dart';

class MessageResponse {
  final User? user;
  final Variant? variant;
  final Product? product;
  final Cart? cart;
  final Location? location;
  final String? errorMessage;
  final String? anotherError;
  final String? successMessage;
  final String? errorMessagePassword;
  final String? errorMessageEmail;

  MessageResponse(
      {this.user,
      this.variant,
      this.product,
      this.cart,
      this.location,
      this.successMessage,
      this.errorMessage,
      this.anotherError,
      this.errorMessagePassword,
      this.errorMessageEmail});
}
