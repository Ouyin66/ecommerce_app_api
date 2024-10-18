import 'package:ecommerce_app_api/config/const.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebView extends StatefulWidget {
  final String url;

  WebView({required this.url});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(
        "https://faq-vn.uniqlo.com/articles/vi/FAQ/%C4%90i%E1%BB%81u-kho%E1%BA%A3n-s%E1%BB%AD-d%E1%BB%A5ng"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                urlLogo2,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Text("UNIQLO", style: subhead),
            ],
          ),
        ),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
