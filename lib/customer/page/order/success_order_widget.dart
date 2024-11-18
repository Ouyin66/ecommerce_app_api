import 'package:ecommerce_app_api/api/api.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/page/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../model/receipt.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';

class SuccessWidget extends StatefulWidget {
  final Receipt receipt;
  const SuccessWidget({super.key, required this.receipt});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  Receipt? receipt;
  String? name;

  void getData() async {
    var user = await APIUser().getUser(receipt!.id!);
    if (user != null)
      return setState(() {
        name = user.user?.name;
      });
  }

  @override
  void initState() {
    super.initState();
    receipt = widget.receipt;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              width: 200,
              height: 200,
              urlSuccess,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 15,
            ),
            _buildBoxDetail(),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: branchColor,
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Trở về trang chủ",
                    style: subhead,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxDetail() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(20),
      dashPattern: [10, 10],
      color: branchColor,
      strokeWidth: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              "Thông tin hóa đơn",
              style: head,
            ),
            SizedBox(
              height: 10,
            ),
            // const DottedLine(
            //   dashColor: blackColor,
            //   dashLength: 5,
            //   dashGapLength: 0,
            //   dashRadius: 8,
            // ),
            SizedBox(
              height: 10,
            ),
            _buildInfo(
                "Hóa đơn:", "HD${receipt?.id.toString().padLeft(10, '0')}"),
            SizedBox(
              height: 10,
            ),
            _buildInfo("Người đặt:", name ?? ''),
            SizedBox(
              height: 10,
            ),
            _buildInfo("Số điện thoại:", receipt?.phone ?? ''),
            SizedBox(
              height: 10,
            ),
            _buildInfo("Địa chỉ:", receipt?.address ?? ''),
            SizedBox(
              height: 10,
            ),
            _buildInfo("Tổng tiền:",
                NumberFormat('###,###.### đ').format(receipt?.total ?? 0)),
            SizedBox(
              height: 10,
            ),
            _buildInfo("Mã giao dịch:", receipt?.paymentId ?? ''),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: GoogleFonts.barlow(
              fontSize: 18,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 7,
          child: Text(
            data,
            style: GoogleFonts.barlow(
              fontSize: 18,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  // Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           stops: [
  //             0.01,
  //             0.2,
  //           ],
  //           colors: [branchColor.withOpacity(0.76), whiteColor],
  //         ),
  //       ), ),
}
