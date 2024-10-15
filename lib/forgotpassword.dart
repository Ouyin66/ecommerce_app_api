import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/const.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
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
                    Text("Địa chỉ email", style: head),
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
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 16),
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "Nhập địa chỉ vào đây...",
                        labelStyle: const TextStyle(
                          color: greyColor,
                          fontSize: 16,
                        ),
                        border: myOutlineInputBorder3(),
                        focusedBorder: myOutlineInputBorder3(),
                        enabledBorder: myOutlineInputBorder1(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }

                        return null;
                      },
                      onChanged: null,
                    ),
                    const SizedBox(
                      height: 20,
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

  dynamic myOutlineInputBorder1() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      borderSide: BorderSide(color: greyColor, width: 1),
    );
  }

  dynamic myOutlineInputBorder2() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      borderSide: BorderSide(color: blackColor, width: 2),
    );
  }

  dynamic myOutlineInputBorder3() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      borderSide: BorderSide(color: blackColor, width: 2),
    );
  }
}
