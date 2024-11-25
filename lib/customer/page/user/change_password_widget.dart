import 'package:ecommerce_app_api/api/api.dart';
import 'package:flutter/material.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../model/user.dart';

class ChangePasswordWidget extends StatefulWidget {
  final User user;
  const ChangePasswordWidget({super.key, required this.user});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _renewpasswordController =
      TextEditingController();
  bool _isHidden = true;
  String? message;

  void changePassword() async {
    var response = await APIUser()
        .ChangePassword(widget.user.id!, _newpasswordController.text);
    if (response?.user != null) {
      if (await saveUser(response!.user!)) {
        widget.user.password = response.user!.password;
        if (response.successMessage != null) {
          message = response.successMessage;
          showToast(context, message!);
        }
        _passwordController.clear();
        _newpasswordController.clear();
        _renewpasswordController.clear();
      } else {
        print("Không saveUser được");
      }
    } else if (response?.errorMessageEmail != null) {
      message = response?.errorMessageEmail;
      showToast(context, message!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Đổi mật khẩu", style: head),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                urlLogo3,
                fit: BoxFit.cover,
                height: 50,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  // width: 300,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(26),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputField(
                          "Mật khẩu cũ",
                          _passwordController,
                          'Nhập mật khẩu cũ',
                          Icons.password,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            } else if (!RegExp(
                                    r'^(?=.*[a-zA-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                                .hasMatch(value)) {
                              return 'Phải từ 6 ký tự, 1 chữ cái, 1 ký tự đặc biệt';
                            } else if (value != widget.user.password) {
                              return 'Mật khẩu cũ không trùng khớp';
                            }

                            return null;
                          },
                          _isHidden,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InputField(
                          "Mật khẩu mới",
                          _newpasswordController,
                          'Nhập mật khẩu mới',
                          Icons.password,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            } else if (!RegExp(
                                    r'^(?=.*[a-zA-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                                .hasMatch(value)) {
                              return 'Phải từ 6 ký tự, 1 chữ cái, 1 ký tự đặc biệt';
                            } else if (value == _passwordController.text) {
                              return 'Mật khẩu mới phải khác mật khẩu cũ';
                            }

                            return null;
                          },
                          _isHidden,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InputField(
                          "Nhập lại mật khẩu",
                          _renewpasswordController,
                          'Nhập lại mật khẩu',
                          Icons.password,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập lại mật khẩu';
                            } else if (value != _newpasswordController.text) {
                              return 'Mật khẩu nhập lại không trùng khớp';
                            }
                            return null;
                          },
                          _isHidden,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: buildButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return ElevatedButton(
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
          changePassword();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "Thay đổi mật khẩu",
          style: subhead,
        ),
      ),
    );
  }

  Widget InputField(
      String label,
      TextEditingController controller,
      String labelText,
      IconData icon,
      String? Function(String?) errorMess,
      bool isHidden) {
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
          obscureText: isHidden ? isHidden : false,
          decoration: InputDecoration(
            hintText: labelText,
            prefixIcon: Icon(
              icon,
              color: greyColor,
            ),
            iconColor: greyColor,
            hintStyle: const TextStyle(
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
            suffixIcon: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: greyColor,
              ),
              onPressed: () {
                setState(() {
                  _isHidden = !_isHidden;
                });
              },
            ),
            errorStyle: error,
          ),
          validator: errorMess,
          onChanged: null,
        ),
      ],
    );
  }
}
