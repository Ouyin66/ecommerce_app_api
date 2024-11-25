import 'package:ecommerce_app_api/api/api.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/page/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main.dart';
import '../../../model/receipt.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:dotted_line/dotted_line.dart';

class SuccessWidget extends StatefulWidget {
  final Receipt receipt;
  const SuccessWidget({super.key, required this.receipt});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  Receipt? receipt;
  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 0;

  void _measureContentHeight() {
    final renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _contentHeight = renderBox.size.height;
      });
      print(_contentHeight);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureContentHeight();
    });
    receipt = widget.receipt;
    print(_contentHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.7],
                colors: [
                  branchColor.withOpacity(0.67),
                  whiteColor.withOpacity(0.97),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBoxReceipt(),
                  SizedBox(
                    height: 40,
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
          ),
        ],
      ),
    );
  }

  Widget _buildBoxReceipt() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.6),
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            _buildTitle(),
            SizedBox(
              height: 15,
            ),
            _buildBoxDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: 70,
                height: 70,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(0.88),
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Thanh toán thành công",
                      style: GoogleFonts.barlow(
                        fontSize: 30,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        text:
                            'Bạn đã thanh toán thành công cho \n mã đơn hàng ',
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          color: blackColor,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                "HD${receipt?.id.toString().padLeft(10, '0')}",
                            style: GoogleFonts.barlow(
                              fontSize: 18,
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 100,
            right: 100,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Nửa vòng tròn nền trắng
                CustomPaint(
                  size: Size(155, 70.13), // Kích thước tổng thể
                  painter: HalfCirclePainter(),
                ),
                // Hình ảnh ở giữa nửa vòng tròn
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(),
                      child: Image.asset(
                        urlSuccess,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image:
                DecorationImage(image: AssetImage(urlLogo2), fit: BoxFit.cover),
          ),
          child: null,
        ),
        SizedBox(
          width: 20,
        ),
        Text.rich(
          TextSpan(
            text: 'Tổng tiền đã thanh toán\n',
            style: GoogleFonts.barlow(
              fontSize: 16,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    NumberFormat('###,###.### đ').format(receipt?.total ?? ''),
                style: GoogleFonts.barlow(
                  fontSize: 30,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildBoxDetail() {
    return Center(
      child: Stack(
        children: [
          // Receipt shape
          CustomPaint(
            size: Size(double.maxFinite, _contentHeight + 35),
            painter: ReceiptCutOutPainter(),
          ),
          // Nội dung
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  key: _contentKey,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBoxTotal(),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      height: 0,
                      thickness: 2,
                      color: greyColor.withOpacity(0.3),
                      indent: 30,
                      endIndent: 30,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildInfo("Mã giao dịch:", receipt?.paymentId ?? ''),
                    SizedBox(
                      height: 10,
                    ),
                    _buildInfo("Người đặt:", receipt?.name ?? ''),
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
                  ],
                ),
              ),
            ),
          ),
        ],
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
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = whiteColor.withOpacity(0.88)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, -pi, pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReceiptCutOutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Main rectangular path with rounded corners
    final mainPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(16), // Bo góc với bán kính 16
      ));

    // Left circular cut-out
    final leftCirclePath = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(0, size.height / 3.6), radius: 20));

    // Right circular cut-out
    final rightCirclePath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width, size.height / 3.6), radius: 20));

    // Combine paths with cut-outs
    final resultPath = Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, mainPath, leftCirclePath),
      rightCirclePath,
    );

    // Draw the final shape
    canvas.drawPath(resultPath, paint);

    // Dotted border setup
    final borderPaint = Paint()
      ..color = branchColor // Màu viền
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Độ dày của viền

    // Vẽ viền dạng chấm với bo góc
    _drawDottedBorder(canvas, resultPath, borderPaint);
  }

  // Hàm vẽ viền dạng chấm
  void _drawDottedBorder(Canvas canvas, Path path, Paint paint) {
    const double dashWidth = 6.0; // Độ dài mỗi đoạn chấm
    const double dashSpace = 4.0; // Khoảng cách giữa các đoạn chấm

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      while (distance < pathMetric.length) {
        final start = distance;
        final end = distance + dashWidth;

        // Vẽ đoạn chấm
        final segment = pathMetric.extractPath(start, end);
        canvas.drawPath(segment, paint);

        // Cập nhật khoảng cách
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
