import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api/api.dart';
import 'config/const.dart';
import 'login_widget.dart';
import 'webview.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isHidden = true;
  String? errorEmail;
  String urlPrivacyPolicy =
      "https://faq-vn.uniqlo.com/pkb_Home_UQ_VN?id=kA32t000000TNUR&l=vi&fs=RelatedArticle";
  String urlTermsOfUse =
      "https://faq-vn.uniqlo.com/articles/vi/FAQ/%C4%90i%E1%BB%81u-kho%E1%BA%A3n-s%E1%BB%AD-d%E1%BB%A5ng";

  void register() async {
    try {
      var response = await APIUser().Register(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _passwordController.text);

      // Kiểm tra phản hồi từ API
      setState(() {
        errorEmail = null;
        if (response?.user != null) {
          showToast(context, "Đăng ký thành công");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginWidget()));
        } else if (response?.errorMessageEmail != null) {
          errorEmail = response?.errorMessageEmail;
        } else if (response?.errorMessage != null) {
          showToast(context, response!.errorMessage!, isError: true);
        }
        _formKey.currentState!.validate();
      });
    } catch (ex) {
      print("Error: $ex");
      showToast(context, "Đăng ký thất bại", isError: true);
    }
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
                Row(
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
                ),
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
                        _nameController,
                        'Nhập tên người dùng...',
                        Icons.person,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên người dùng';
                          }
                          if (value.length < 3) {
                            return 'Tên người dùng phải từ 3 ký tự trở lên';
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
                          return errorEmail;
                        },
                      ),
                      const SizedBox(height: 15),
                      InputField(
                        "Số điện thoại",
                        _phoneController,
                        'Số điện thoại...',
                        Icons.phone,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          } else if (value.length < 10) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                        isPhone: true,
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

                          return null;
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
                          return null;
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
                      FormField(
                          initialValue: _acceptTerms,
                          validator: (value) {
                            if (value != true) {
                              return '*Bạn phải đồng ý với các điều khoản trên';
                            }
                            return null;
                          },
                          builder: (FormFieldState<bool> state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: state.value,
                                      onChanged: (value) {
                                        setState(() {
                                          _acceptTerms = value ?? false;
                                          state.didChange(value);
                                        });
                                      },
                                      isError: state.hasError ? true : false,
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
                                                  WebView(
                                                      url: urlPrivacyPolicy)),
                                            ),
                                            TextSpan(
                                                text: 'của UNIQLO',
                                                style: body),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.hasError)
                                  Text(
                                    state.errorText!,
                                    style: error,
                                  ),
                              ],
                            );
                          }),
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
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('Form hợp lệ')),
                            // );
                            register();
                          } else if (errorEmail != null) {
                            register();
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
      {bool isPhone = false, bool isPassword = false, bool isHidden = false}) {
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
          keyboardType: isPhone ? TextInputType.number : null,
          inputFormatters: isPhone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : [],
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
                      _isHidden ? Icons.visibility_off : Icons.visibility,
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
