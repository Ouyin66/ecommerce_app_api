import 'package:ecommerce_app_api/api/api.dart';
import 'package:ecommerce_app_api/api/sharepre.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/forgot_password_widget.dart';
import 'package:ecommerce_app_api/customer/register_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customer/page/main.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHidden = true;

  void login() async {
    try {
      var user = await APIRepository()
          .login(_emailController.text, _passwordController.text);
      saveUser(user);
      print(user.name);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    } catch (ex) {
      print("Error: $ex");
      showErrorDialog("Đăng nhập thất bại");
    }
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Lỗi đăng nhập",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(error),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Logo(),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        "Email",
                        _emailController,
                        'Email...',
                        Icons.email,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null; // Nếu không có lỗi
                        },
                      ),
                      const SizedBox(height: 15),
                      InputField(
                        "Mật khẩu",
                        _passwordController,
                        'Mật khẩu...',
                        Icons.password,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          } else if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null; // Trả về null nếu hợp lệ
                        },
                        isPassword: true,
                        isHidden: _isHidden,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordWidget(),
                                  ),
                                );
                              },
                              child: Text(
                                'Bạn quên mật khẩu?',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.barlow(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 8,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const MainWidget(),
                      //   ),
                      // );
                      if (_formKey.currentState!.validate()) {
                        // Nếu form hợp lệ, thực hiện hành động
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Form hợp lệ')),
                        );
                        login();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Đăng nhập",
                        style: subhead,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      color: greyColor,
                      width: 120,
                    ),
                    Spacer(),
                    Text(
                      "Hoặc",
                      style: GoogleFonts.barlow(
                        fontSize: 16,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 1,
                      color: greyColor,
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GoogleSignIn(),
                SizedBox(
                  height: 15,
                ),
                FacebookSignIn(),
                SizedBox(
                  height: 60,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Bạn chưa có tài khoản? ',
                    style: body,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Đăng ký',
                        style: GoogleFonts.barlow(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        ),
                        recognizer: _tapRecognizer(RegisterWidget()),
                      ),
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

  Widget Logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }

  Widget GoogleSignIn() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: whiteColor,
          foregroundColor: blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 8,
        ),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const MainWidget(),
          //   ),
          // );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                urlGoogleLogo,
                width: 24,
                height: 24,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Đăng nhập bằng Google",
                style: subhead,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FacebookSignIn() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: whiteColor,
          foregroundColor: blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 8,
        ),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const MainWidget(),
          //   ),
          // );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                urlFacebookLogo,
                width: 24,
                height: 24,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Đăng nhập bằng Facebook",
                style: subhead,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TapGestureRecognizer _tapRecognizer(Widget widget) {
    return TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      };
  }

  Widget InputField(String label, TextEditingController controller,
      String labelText, IconData icon, String? Function(String?) errorMess,
      {bool isPassword = false, bool isHidden = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: subhead,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 16),
          obscureText: isPassword ? isHidden : false,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(
              icon,
              color: greyColor,
            ),
            iconColor: greyColor,
            labelStyle: const TextStyle(
              color: greyColor,
              fontSize: 16,
            ),
            border: FocusBorder(),
            focusedBorder: FocusBorder(),
            enabledBorder: EnableBorder(),
            errorBorder: ErrorBorder(),
            focusedErrorBorder: ErrorFocusBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                      color: greyColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    },
                  )
                : null,
            errorStyle: error,
          ),
          validator: errorMess,
          onChanged: null,
        ),
      ],
    );
  }
}
