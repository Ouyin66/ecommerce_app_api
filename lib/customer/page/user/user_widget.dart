import 'dart:io';

import 'package:ecommerce_app_api/api/api.dart';
import 'package:ecommerce_app_api/customer/page/user/change_password_widget.dart';
import 'package:ecommerce_app_api/customer/page/user/location_widget.dart';
import 'package:ecommerce_app_api/model/selectedcart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../login_widget.dart';
import '../../../main.dart';
import '../../../model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'edit_user_widget.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> with RouteAware {
  User? user = User.userEmpty();
  String? _selectedImage;

  void logout() async {
    await deleteUser();
    SelectedCart().MakeNull();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      user = User.userEmpty();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
      print("Đăng xuất thành công");
    } else {
      print("Đăng xuất không thành công");
    }
  }

  void checkLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginWidget()));
    } else {
      getDataUser();
    }
  }

  void updatePicture() async {
    if (_selectedImage != null) {
      user?.image = _selectedImage;
    }

    var response = await APIUser().updateInformation(user!);
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
    } else {
      print("Không tìm thấy user");
    }
    setState(() {});
  }

  void deleteAccount() async {
    print("Xóa tài khoản");
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      MainApp.routeObserver.subscribe(this, route as PageRoute<dynamic>);
    }
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    checkLogout();
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
              Text("Thông tin cá nhân", style: head),
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
      body: user?.id == null
          ? LoadingScreen()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        buildImage(128),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: buildEditIcon(branchColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildName(),
                    SizedBox(
                      height: 20,
                    ),
                    buildBox(),
                    SizedBox(
                      height: 20,
                    ),
                    builSecondBox(),
                    SizedBox(
                      height: 20,
                    ),
                    builThirdBox(),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // _selectedImage != null
                    //     ? Image.file(_selectedImage!)
                    //     : Text("Please selected an image"),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImage(double size) {
    final imageUrl;
    if (user?.image == null || user?.image == '') {
      imageUrl = urlLogo;
    } else {
      imageUrl = user?.image;
    }
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _myShowBottomSheet(context);
          },
          child: imageUrl == urlLogo
              ? Image.asset(
                  imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_rounded),
                )
              : Image.network(
                  imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Ink.image(
                          image: FileImage(File(imageUrl!)),
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          child: InkWell(
                            onTap: () {
                              _myShowBottomSheet(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
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

  Widget buildName() {
    return Column(
      children: [
        Text(
          user?.name ?? '',
          style: head,
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          user?.email ?? '',
          style: GoogleFonts.barlow(
            fontSize: 18,
            color: greyColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Widget buildBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(
                Radius.circular(26),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(
                  Icons.password_rounded,
                  "Đổi mật khẩu",
                  widget: ChangePasswordWidget(user: user!),
                ),
                Divider(
                  height: 30,
                ),
                buildButton(
                  Icons.edit_note_rounded,
                  "Chỉnh sửa thông tin người dùng",
                  widget: EditUserWidget(),
                ),
                Divider(
                  height: 30,
                ),
                buildButton(
                  Icons.location_on_outlined,
                  "Địa chỉ giao hàng",
                  widget: LocationWidget(user: user!),
                ),
                Divider(
                  height: 30,
                ),
                buildButton(Icons.logout_rounded, "Đăng xuất", isLogout: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget builSecondBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(
                Radius.circular(26),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(
                  Icons.settings_outlined,
                  "Cài đặt",
                ),
                Divider(
                  height: 30,
                ),
                buildButton(Icons.delete_forever_rounded, "Xóa tài khoản",
                    function: deleteAccount, isLogout: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(IconData icon, String label,
      {Widget? widget = null, Function? function, bool isLogout = false}) {
    return InkWell(
      onTap: () {
        if (isLogout && function != null) {
          function();
        } else if (isLogout) {
          logout();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget!),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isLogout ? branchColor : blackColor,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.barlow(
                fontSize: 18,
                color: isLogout ? branchColor : blackColor,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                // height: 1,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget builThirdBox() {
    var formattedDate;

    if (user!.dateCreate != null) {
      DateTime dateTime = DateTime.parse(user!.dateCreate!);
      formattedDate = DateFormat('HH:mm:ss dd/MM/yyyy').format(dateTime);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(
                Radius.circular(26),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Phiên bản của ứng dụng 1.1.1.1",
                  style: GoogleFonts.barlow(
                    fontSize: 18,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    // height: 1,
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Text(
                  "Tài khoản tạo ngày: ${formattedDate ?? ''}",
                  style: GoogleFonts.barlow(
                    fontSize: 18,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    // height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _myShowBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext contextSheet) {
        return StatefulBuilder(
          builder: (BuildContext contextSheet, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    child: Text(
                      "Chọn ảnh từ thư viện",
                      style: label,
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      _pickImageFromCamera();
                    },
                    child: Text(
                      "Chụp ảnh",
                      style: label,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // IMAGE
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = returnedImage.path;
    });
    updatePicture();
    print(_selectedImage);
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = returnedImage.path;
    });
    updatePicture();
    print(_selectedImage);
  }
}
