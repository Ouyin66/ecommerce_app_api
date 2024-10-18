import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/const.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
                Image.asset(
                  urlForgetPassword,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BẠN QUÊN MẬT KHẨU?", style: head),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      color: blackColor,
                      width: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Nhập địa chỉ email được liên kết với tài khoản của bạn",
                        style: body),
                    const SizedBox(
                      height: 35,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 16),
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Nhập địa chỉ vào đây...",
                          labelStyle: const TextStyle(
                            color: greyColor,
                            fontSize: 16,
                          ),
                          border: FocusBorder(),
                          focusedBorder: FocusBorder(),
                          enabledBorder: EnableBorder(),
                          errorBorder: ErrorBorder(),
                          focusedErrorBorder: ErrorFocusBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: error,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null; // Nếu không có lỗi
                        },
                        onChanged: null,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                "Khôi phục",
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

  Widget BackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back), // Icon cho nút
      onPressed: () {
        Navigator.pop(context); // Quay lại màn hình trước
      },
    );
  }
}
