import 'package:ecommerce_app_api/model/selectedcart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/api.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../login_widget.dart';
import '../../../model/user.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({super.key});

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateCreateController = TextEditingController();
  int? _selectedGender;
  User user = User.userEmpty();

  void changeInformation() async {
    var response = await APIUser().updateInformation(user);
    if (response?.user != null) {
      if (await saveUser(response!.user!)) {
        if (response.successMessage != null) {
          showToast(context, response.successMessage!);
        }
        print(
            "${response.user!.id}, ${response.user!.name}, ${response.user!.phone}, ${response.user!.gender}");
        getDataUser();
      } else {
        print("Không saveUser được");
      }
    } else if (response?.errorMessageEmail != null) {
      showToast(context, response!.errorMessageEmail!, isError: true);
    }
  }

  void getDataUser() async {
    user = await getUser();
    if (user != null) {
      print("Tìm thấy user");
      _nameController.text = user.name!;
      _emailController.text = user.email!;
      _phoneController.text = user.phone!;
      _passwordController.text = "*********${user.password!.characters.last}";
      _dateCreateController.text = user.dateCreate!;
      _selectedGender = user.gender;
    } else {
      print("Không tìm thấy user");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
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
              Text("Chỉnh sửa thông tin", style: head),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    buildImage(),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: buildEditIcon(branchColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Chỉnh sửa hình ảnh",
                  style: GoogleFonts.barlow(
                    fontSize: 18,
                    color: branchColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                buildBox(),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: buildButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: NetworkImage(user.image!),
          width: 128,
          height: 128,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: whiteColor,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            size: 20,
            color: whiteColor,
          ),
        ),
      );

  Widget buildCircle({
    required Color color,
    required double all,
    required Widget child,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: greyColor.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(26),
              ),
            ),
            child: buildEditInformation(),
          ),
        ),
      ],
    );
  }

  Widget buildEditInformation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildCustomTextFormField(
                icon: Icons.person,
                label: "Tên người dùng",
                controller: _nameController,
              ),
              Divider(
                height: 10,
              ),
              buildCustomTextFormField(
                icon: Icons.email_rounded,
                label: "Email",
                controller: _emailController,
                isView: true,
              ),
              Divider(
                height: 10,
              ),
              buildCustomTextFormField(
                icon: Icons.phone_android_rounded,
                label: "Số điện thoại",
                controller: _phoneController,
                isPhone: true,
              ),
              Divider(
                height: 10,
              ),
              buildCustomTextFormField(
                icon: Icons.password_rounded,
                label: "Mật khẩu",
                controller: _passwordController,
                isView: true,
              ),
              Divider(
                height: 10,
              ),
              buildDropdownFormField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCustomTextFormField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool isView = false,
    bool isPhone = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: blackColor), // Icon nằm ở bên trái
        SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: 16,
            color: blackColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: isView,
            keyboardType: isPhone ? TextInputType.number : null,
            inputFormatters: isPhone
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Điền thông tin...',
              hintStyle: GoogleFonts.barlow(
                fontSize: 16,
                color: greyColor,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              errorStyle: error,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng điền đủ thông tin';
              } else if (isPhone && value.length < 10) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
            style: GoogleFonts.barlow(
              fontSize: 16,
              color: isView ? greyColor : blackColor,
              fontWeight: FontWeight.bold,
              fontStyle: isView ? FontStyle.italic : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget buildDropdownFormField() {
    final List<Map<String, dynamic>> genderList = [
      {'id': 0, 'label': 'Nam'},
      {'id': 1, 'label': 'Nữ'},
      {'id': 2, 'label': 'Khác'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.transgender, color: blackColor), // Icon nằm ở bên trái
        SizedBox(width: 10),
        Text(
          "Giới tính",
          style: GoogleFonts.barlow(
            fontSize: 16,
            color: blackColor,
            fontWeight: FontWeight.normal,
          ),
        ), // Label ở giữa
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedGender,
            decoration: InputDecoration(
              hintText: "Chọn giới tính",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 120, right: 0),
              hintStyle: GoogleFonts.barlow(
                fontSize: 16,
                color: greyColor,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              errorStyle: error,
            ),
            validator: (value) {
              if (value == null) {
                return 'Vui lòng điền đủ thông tin';
              }
              return null;
            },
            dropdownColor: whiteColor,
            alignment: Alignment.centerLeft,
            items: genderList.map((gender) {
              return DropdownMenuItem<int>(
                value: gender['id'],
                child: Text(
                  gender['label'],
                  style: GoogleFonts.barlow(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
        ),
      ],
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
          user.name = _nameController.text;
          user.phone = _phoneController.text;
          user.gender = _selectedGender;
          changeInformation();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "Cập nhật thông tin",
          style: subhead,
        ),
      ),
    );
  }
}
