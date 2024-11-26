import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/page/order/success_order_widget.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
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
  await Stripe.instance.applySettings();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  @override
  Widget build(BuildContext context) {
    // Receipt receipt = Receipt(
    //   id: 2,
    //   userId: 2,
    //   name: "Nguyễn Phương Hồng Nhã",
    //   address: "36 Đ. Trần Thị Trọng, Phường 15, Tân Bình, Hồ Chí Minh",
    //   phone: "0916677676",
    //   discount: 0,
    //   total: 588000,
    //   paymentId: "pi_3QOlG0D6t5ZfQvhu0UOx0ShC",
    //   interest: false,
    //   dateCreate: "2024-11-25T02:14:44.753",
    //   receiptVariants: [],
    // );
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
      // home: SuccessWidget(receipt: receipt),
      navigatorObservers: [routeObserver],
    );
  }
}
