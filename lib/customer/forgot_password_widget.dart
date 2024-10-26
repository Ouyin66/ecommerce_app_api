import 'package:flutter/material.dart';
import '../api/api.dart';
import '../config/const.dart';
import '../login_widget.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? errorMessage;

  void forgotPassword() async {
    try {
      var response = await APIUser().forgotPassword(_emailController.text);

      setState(() {
        errorMessage = null;

        if (response?.successMessage != null) {
          showErrorDialog(context, response!.successMessage!, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginWidget()));
        } else if (response?.errorMessageEmail != null) {
          errorMessage = response?.errorMessageEmail;
        } else if (response?.errorMessage != null) {
          showErrorDialog(context, response!.errorMessage!, true);
        }
        _formKey.currentState!.validate();
      });
    } catch (ex) {
      print("Error: $ex");
      showErrorDialog(context, "Khôi phục thất bại", true);
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
                  height: 40,
                ),
                Image.asset(
                  urlForgetPassword,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 40,
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
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 16),
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Nhập địa chỉ email vào đây...",
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
                          return errorMessage; // Nếu không có lỗi
                        },
                        onChanged: null,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                forgotPassword();
                              } else if (errorMessage != null) {
                                forgotPassword();
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

  Widget BackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back), // Icon cho nút
      onPressed: () {
        Navigator.pop(context); // Quay lại màn hình trước
      },
    );
  }
}
