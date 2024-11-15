import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/model/selectedcart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  await _setup();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedCart()),
      ],
      child: MainApp(),
    ),
  );
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dividerColor: blackColor,
      ),
      home: const LoginWidget(),
      navigatorObservers: [routeObserver],
    );
  }
}
