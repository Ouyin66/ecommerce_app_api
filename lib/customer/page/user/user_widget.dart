import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../login_widget.dart';
import '../../../model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  User user = User.userEmpty();

  void logout() async {
    await deleteUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      user = User.userEmpty();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    } else {
      print("Đăng xuất không thành công");
    }
  }

  void getDataUser() async {
    user = await getUser();
    if (user != null) {
      print("Tìm thấy user");
    } else {
      print("Không tìm thấy user");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Thông tin cá nhân", style: head),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                urlLogo3,
                fit: BoxFit.cover,
                height: 50,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: whiteColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60)),
                              image: DecorationImage(
                                image: NetworkImage("${user.image}"),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) =>
                                    const Icon(Icons.image),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Xin chào,',
                              style: GoogleFonts.barlow(
                                fontSize: 20,
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\n${user.name}',
                                  style: label20,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              logout();
                            },
                            icon: Icon(
                              Icons.logout_rounded,
                              color: branchColor,
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: whiteColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      information("Email: ", user.email.toString()),
                      information(
                          "Số điện thoại: ",
                          user.phone != ''
                              ? user.phone.toString()
                              : "Chưa cung cấp"),
                      information(
                          "Địa chỉ giao hàng: ",
                          user.location != ''
                              ? user.location.toString()
                              : "Chưa cung cấp"),
                      information(
                          "Giới tính: ",
                          user.gender != null
                              ? (user.gender == 0)
                                  ? "Nam"
                                  : "Nữ"
                              : "Chưa cung cấp"),
                      information(
                          "Ngày tạo tài khoản: ",
                          user.dateCreate != ''
                              ? DateFormat('dd-MM-yyyy HH:mm:ss').format(
                                  DateTime.parse(user.dateCreate.toString()))
                              : "Chưa cập nhật"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget information(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: infoLabel,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          data,
          style: info,
          softWrap: true,
          maxLines: 3,
        ),
      ],
    );
  }
}
