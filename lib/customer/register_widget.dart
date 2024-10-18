import 'package:ecommerce_app_api/webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/const.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  bool agree = false;
  bool _isHidden = true;
  String urlPrivacyPolicy =
      "https://faq-vn.uniqlo.com/pkb_Home_UQ_VN?id=kA32t000000TNUR&l=vi&fs=RelatedArticle";
  String urlTermsOfUse =
      "https://faq-vn.uniqlo.com/articles/vi/FAQ/%C4%90i%E1%BB%81u-kho%E1%BA%A3n-s%E1%BB%AD-d%E1%BB%A5ng";

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
                        "Tên người dùng",
                        _personController,
                        'Nhập tên người dùng...',
                        Icons.person,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null; // Trả về null nếu hợp lệ
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
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
                          } else if (!RegExp(
                                  r'^(?=.*[a-zA-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                              .hasMatch(value)) {
                            return 'Phải từ 6 ký tự, 1 chữ cái, 1 ký tự đặc biệt';
                          }

                          return null; // Trả về thông báo lỗi nếu có
                        },
                        isPassword: true,
                        isHidden: _isHidden,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        "Nhập lại mật khẩu",
                        _repasswordController,
                        'Nhập lại mật khẩu...',
                        Icons.password,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập lại mật khẩu';
                          } else if (value != _passwordController.text) {
                            return 'Mật khẩu nhập lại không trùng khớp';
                          }
                          return null; // Trả về null nếu hợp lệ
                        },
                        isPassword: true,
                        isHidden: _isHidden,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Thỏa thuận thành viên ',
                          style: subhead,
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: GoogleFonts.barlow(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // can add more TextSpans here...
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Bằng cách tạo tài khoản, bạn đồng ý với các điều khoản sử dụng và chính sách quyền riêng tư của UNIQLO",
                        style: GoogleFonts.barlow(
                          fontSize: 16,
                          color: blackColor,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: agree,
                            onChanged: (value) {
                              setState(() {
                                agree = value!;
                              });
                            },
                            activeColor: branchColor,
                            checkColor: whiteColor,
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Tôi đồng ý với ',
                                style: body,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'ĐIỀU KHOẢN SỬ DỤNG ',
                                    style: subhead,
                                    recognizer: _tapRecognizer(
                                        WebView(url: urlTermsOfUse)),
                                  ),
                                  TextSpan(text: 'và ', style: body),
                                  TextSpan(
                                    text: 'CHÍNH SÁCH RIÊNG TƯ ',
                                    style: subhead,
                                    recognizer: _tapRecognizer(
                                        WebView(url: urlPrivacyPolicy)),
                                  ),
                                  TextSpan(text: 'của UNIQLO', style: body),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: branchColor,
                          foregroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.black.withOpacity(0.5),
                          elevation: 8,
                        ),
                        padding: EdgeInsets.all(12),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 24,
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
                          if (_formKey.currentState!.validate()) {
                            // Nếu form hợp lệ, thực hiện hành động
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Form hợp lệ')),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Đăng ký",
                            style: subhead,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
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
