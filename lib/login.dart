import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/forgotpassword.dart';
import 'package:ecommerce_app_api/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email", style: subhead),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 16),
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "Email...",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: greyColor,
                        ),
                        iconColor: greyColor,
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
                    const SizedBox(height: 15),
                    Text(
                      "Mật khẩu",
                      style: subhead,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(fontSize: 16),
                      obscureText: true, // Để ẩn ký tự mật khẩu
                      decoration: InputDecoration(
                        labelText: "Mật khẩu...",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: greyColor,
                        ),
                        iconColor: greyColor,
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
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                      onChanged: null,
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
                                  builder: (context) => ForgotPasswordWidget(),
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
                          width: 150,
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
                          width: 150,
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
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn chưa có tài khoản?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: blackColor,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterWidget(),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              const Text(
                                'Đăng ký',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  height: 1,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
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
