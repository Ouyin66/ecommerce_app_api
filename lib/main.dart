import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/model/selectedcart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      // locale: Locale('vi'),
      supportedLocales: [
        Locale('en'), // Tiếng Anh
        Locale('vi'), // Tiếng Việt
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Hỗ trợ cho iOS
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dividerColor: blackColor,
      ),
      home: const LoginWidget(),
      navigatorObservers: [routeObserver],
    );
  }
}
