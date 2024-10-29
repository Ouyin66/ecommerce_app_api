import 'product.dart';
import 'cart.dart';
import 'user.dart';
import 'variant.dart';

class MessageResponse {
  final User? user;
  final Variant? variant;
  final Product? product;
  final Cart? cart;
  final String? errorMessage;
  final String? successMessage;
  final String? errorMessagePassword;
  final String? errorMessageEmail;

  MessageResponse(
      {this.user,
      this.variant,
      this.product,
      this.cart,
      this.successMessage,
      this.errorMessage,
      this.errorMessagePassword,
      this.errorMessageEmail});
}
