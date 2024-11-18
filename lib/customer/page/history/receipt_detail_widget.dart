import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:flutter/material.dart';

class ReceiptDetailWidget extends StatefulWidget {
  final Receipt receipt;
  const ReceiptDetailWidget({super.key, required this.receipt});

  @override
  State<ReceiptDetailWidget> createState() => _ReceiptDetailWidgetState();
}

class _ReceiptDetailWidgetState extends State<ReceiptDetailWidget> {
  //"HD${receipt?.id.toString().padLeft(10, '0')}"

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
