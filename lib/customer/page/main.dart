import 'package:ecommerce_app_api/api/sharepre.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user = User.userEmpty();

  getDataUser() async {
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
