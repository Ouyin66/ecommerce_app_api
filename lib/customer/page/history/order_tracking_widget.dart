import 'package:flutter/material.dart';

import '../../../config/const.dart';

class OrderTrackingWidget extends StatefulWidget {
  const OrderTrackingWidget({super.key});

  @override
  State<OrderTrackingWidget> createState() => _OrderTrackingWidgetState();
}

class _OrderTrackingWidgetState extends State<OrderTrackingWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
