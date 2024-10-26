import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/const.dart';
import '../../../login_widget.dart';
import '../../../model/user.dart';
import 'dart:convert';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  User user = User.userEmpty();

  void logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginWidget()),
    );
  }

  void getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');
    if (strUser != null) {
      user = User.fromJson(jsonDecode(strUser));
      setState(() {});
    } else {
      print("Không tìm thấy user");
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.email.toString()),
            Text(user.password.toString()),
            Text(user.name.toString()),
          ],
        ),
      ),
    );
  }
}
