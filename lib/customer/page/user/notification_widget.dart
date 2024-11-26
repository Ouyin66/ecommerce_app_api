import 'package:ecommerce_app_api/api/api_notification.dart';
import 'package:ecommerce_app_api/api/api_receipt.dart';
import 'package:ecommerce_app_api/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../model/receipt.dart';
import '../../../model/user.dart';
import 'package:intl/intl.dart';

import '../history/receipt_detail_widget.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  User user = User(id: 0);
  List<MyNotification> lst = [];
  List<MyNotification> lstNew = [];
  List<MyNotification> lstOld = [];

  bool _isLoading = true;

  Future<void> getDataUser() async {
    user = await getUser();
    print("Tìm thấy user");
    getNotification(user.id!);
    setState(() {});
  }

  void getNotification(int userId) async {
    var response = await APINotification().GetList(userId);
    if (response != null) {
      lst = List.from(response);
      lstNew = lst.where((item) => item.isRead == false).toList();
      lstOld = lst.where((item) => item.isRead == true).toList();
    } else {
      print("Không tìm thấy");
    }

    setState(() {});
  }

  void isRead(int notificationId) async {
    var response = await APINotification().IsRead(notificationId);
    if (response?.successMessage != null || response?.notification != null) {
      getNotification(user.id!);
    } else {
      print("Lỗi cập nhật IsRead");
    }

    setState(() {});
  }

  Future<Receipt?> getReceipt(int receiptId) async {
    var response = await APIReceipt().Get(receiptId);
    if (response != null) {
      return response;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    await getDataUser();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: whiteColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    lstNew.isNotEmpty || lstNew.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: _buildSecondTitle("Chưa xem"),
                          )
                        : SizedBox(),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    _BuildList(lstNew),
                    lstOld.isNotEmpty || lstOld.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: _buildSecondTitle("Đã xem"),
                          )
                        : SizedBox(),
                    _BuildList(lstOld),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'THÔNG BÁO',
            style: GoogleFonts.barlow(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Divider(
            thickness: 2,
            color: blackColor,
          ),
          SizedBox(height: 5),
        ],
      );

  Widget _buildSecondTitle(String title) => Text(
        title,
        style: GoogleFonts.barlow(
          color: blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      );

  Widget _BuildList(List<MyNotification> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: list.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        var item = list[index];
        return _buildNotification(item, context);
      },
    );
  }

  Widget _buildNotification(MyNotification item, BuildContext context) {
    String? firstPart;
    String? lastPart;

    DateTime dateTime = DateTime.parse(item.dateCreated!);
    var formattedDate = DateFormat('HH:mm:ss dd/MM/yyyy').format(dateTime);

    if (item.type == 'Receipt') {
      firstPart = item.message!.substring(0, item.message!.length - 12);
      lastPart = item.message!.substring(item.message!.length - 12);
    }

    return InkWell(
      onTap: () async {
        print(item.isRead);
        if (item.isRead == false) {
          isRead(item.id!);
        }

        if (item.type == 'Receipt') {
          var obj = await getReceipt(item.id!);
          if (obj != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptDetailWidget(receipt: obj),
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: item.type == 'Receipt'
                    ? Text.rich(
                        TextSpan(
                          text: firstPart ?? '',
                          style: GoogleFonts.barlow(
                            color: blackColor.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: lastPart ?? '',
                              style: GoogleFonts.barlow(
                                color: blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      )
                    : Text(
                        item.message.toString(),
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              Spacer(),
              Expanded(
                flex: 3,
                child: Text(
                  formattedDate,
                  style: GoogleFonts.barlow(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: blackColor.withOpacity(0.1),
              ),
              // boxShadow: item.isRead == true
              //     ? null
              //     : [
              //         BoxShadow(
              //             blurStyle: BlurStyle.normal,
              //             color: blackColor.withAlpha(15),
              //             blurRadius: 0.5,
              //             spreadRadius: 1,
              //             offset: Offset(0, -4)),
              //       ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
