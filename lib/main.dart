import 'package:flutter/material.dart';

import 'login_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginWidget(),
      navigatorObservers: [routeObserver],
    );
  }
}
