import 'package:dio/dio.dart';
import 'package:ecommerce_app_api/api/api_receipt.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ecommerce_app_api/config/const.dart';

import '../page/order/success_order_widget.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(
      String name, String email, Receipt receipt, BuildContext context) async {
    try {
      final response = await _createPaymentIntent(receipt.total!, "vnd");
      if (response == null || response['paymentIntentClientSecret'] == null)
        return;

      receipt.paymentId = response['paymentIntentId'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response['paymentIntentClientSecret'],
          merchantDisplayName: "eCommerce App API",
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: branchColor,
            ),
            shapes: PaymentSheetShape(
              borderRadius: 10, // Bo góc
            ),
          ),
          billingDetails: BillingDetails(
              name: name,
              email: email,
              address: Address(
                  city: null,
                  country: 'VN',
                  line1: null,
                  line2: null,
                  postalCode: null,
                  state: null)),
        ),
      );
      await _processPayment(receipt, context);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
      double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        // Trả về cả client_secret và paymentIntent.id
        return {
          'paymentIntentClientSecret': response.data["client_secret"],
          'paymentIntentId': response.data["id"],
        };
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _processPayment(Receipt receipt, BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Thanh toán thành công");

      _onPaymentSuccess(receipt, context);
    } on StripeException catch (e) {
      print("Thanh toán không thành công: ${e.error.localizedMessage}");
      _onPaymentFailed(e.error.localizedMessage);
    } catch (e) {
      print("Lỗi không xác định: $e");
    }
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = amount.toInt();
    return calculatedAmount.toString();
  }

  void _onPaymentSuccess(Receipt receipt, BuildContext context) async {
    var response = await APIReceipt().createReceipt(receipt);
    if (response != null) {
      print(response);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessWidget(
                  receipt: response,
                )),
      );
      print("Đã xử lý thanh toán thành công");
    } else {
      print("Không tạo được receipt");
    }
  }

  void _onPaymentFailed(String? errorMessage) {
    print("Thanh toán thất bại: $errorMessage");
  }
}
