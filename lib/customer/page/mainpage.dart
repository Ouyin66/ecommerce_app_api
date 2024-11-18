import 'package:ecommerce_app_api/config/const.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';

import 'favorite/favorite_widget.dart';
import 'history/history_widget.dart';
import 'home/home_widget.dart';
import 'user/notification_widget.dart';
import 'user/user_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user = User.userEmpty();

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    FavoriteWidget(),
    NotificationWidget(),
    HistoryWidget(),

    // UserWidget(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserWidget()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getDataUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: branchColor, width: 2.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: const EdgeInsets.all(10),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildNavItem(Icons.home_outlined, Icons.home_rounded, 0),
                      _buildNavItem(
                          Icons.favorite_border_outlined, Icons.favorite, 1),
                      _buildNavItem(Icons.notifications_none_outlined,
                          Icons.notifications, 2),
                      _buildNavItem(
                          Icons.receipt_long_rounded, Icons.receipt_long, 3),
                      _buildNavItem(
                          Icons.person_outline_outlined, Icons.person, 4),
                    ],
                  ),
                  // Positioned(
                  //   child: Transform.scale(
                  //     scale: 1.3, // Điều chỉnh giá trị này để tăng kích thước
                  //     child: FloatingActionButton(
                  //       onPressed: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //       builder: (context) =>
                  //         //           const BookingWidget()),
                  //         // );
                  //       },
                  //       backgroundColor: Colors.black,
                  //       shape: const CircleBorder(), // Đảm bảo hình tròn
                  //       child: const Icon(
                  //         Icons.calendar_view_week_rounded,
                  //         size: 26,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData iconSelected, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(10),
        child: Icon(
          _selectedIndex == index ? iconSelected : icon,
          color: _selectedIndex == index ? branchColor : blackColor,
          size: 30,
        ),
      ),
    );
  }
}
