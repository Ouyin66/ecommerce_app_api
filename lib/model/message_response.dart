import 'package:ecommerce_app_api/model/notification.dart';
import 'package:ecommerce_app_api/model/order_status_history.dart';
import 'package:ecommerce_app_api/model/promotion.dart';

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
  final Promotion? promotion;
  final MyNotification? notification;
  final OrderStatusHistory? status;
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
      this.promotion,
      this.notification,
      this.status,
      this.successMessage,
      this.errorMessage,
      this.anotherError,
      this.errorMessagePassword,
      this.errorMessageEmail});
}
