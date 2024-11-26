import 'dart:io';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../model/user.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  Uint8List? _selectedImage;

  void changeInformation() async {
    var response = await APIUser().UpdateInformation(user);
    if (response?.user != null) {
      if (await saveUser(response!.user!)) {
        if (response.successMessage != null) {
          showToast(context, response.successMessage!);
        }
        print(
            "${response.user!.id}, ${response.user!.name}, ${response.user!.phone}, ${response.user!.gender}");
        getDataUser();
        _selectedImage = null;
      } else {
        print("Không saveUser được");
      }
    } else if (response?.errorMessageEmail != null) {
      showToast(context, response!.errorMessageEmail!, isError: true);
    }
  }

  void updatePicture() async {
    if (_selectedImage != null) {
      user.image = _selectedImage;
    }

    var response = await APIUser().UpdateInformation(user);
    if (response?.user != null) {
      if (await saveUser(response!.user!)) {
        if (response.successMessage != null) {
          showToast(context, response.successMessage!);
        }
        _selectedImage = null;
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
    print("Tìm thấy user");
    _nameController.text = user.name!;
    _emailController.text = user.email!;
    _phoneController.text = user.phone!;
    _passwordController.text = "*********${user.password!.characters.last}";
    _dateCreateController.text = user.dateCreate!;
    _selectedGender = user.gender;
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
                    buildImage(128),
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

  Widget buildImage(double size) {
    final imageUrl;
    if (user.image == null || user.image == '') {
      imageUrl = urlLogo;
    } else {
      imageUrl = user.image;
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
                  imageUrl ?? '',
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_rounded),
                )
              : isAvifFile(imageUrl) != AvifFileType.unknown
                  ? AvifImage.memory(
                      imageUrl ?? '',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
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
                    )
                  : Image.memory(
                      imageUrl ?? '',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
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
              color: greyColor.withOpacity(0.1),
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
                fontWeight: FontWeight.w500,
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
                      _pickImageFromGallery(context);
                    },
                    child: Text(
                      "Chọn ảnh từ thư viện",
                      style: label,
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      _pickImageFromCamera(context);
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
  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List fileBytes = await pickedFile.readAsBytes();
      if (fileBytes.length > 5610) {
        final compressedImage = await FlutterImageCompress.compressWithList(
          fileBytes,
          quality: 15,
          minWidth: 300,
          minHeight: 300,
        );

        if (compressedImage.length > 5610) {
          _showErrorDialog(context, compressedImage.length);
        } else {
          setState(() {
            _selectedImage = compressedImage;
          });
          updatePicture();
          print('Ảnh đã chọn, kích thước: ${compressedImage.length} bytes');
        }
      } else {
        setState(() {
          _selectedImage = fileBytes;
        });
        updatePicture();
        print('Ảnh đã chọn, kích thước: ${fileBytes.length} bytes');
      }
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final Uint8List fileBytes = await pickedFile.readAsBytes();
      if (fileBytes.length > 5610) {
        final compressedImage = await FlutterImageCompress.compressWithList(
          fileBytes,
          quality: 30,
          minWidth: 500,
          minHeight: 500,
        );

        if (compressedImage.length > 5610) {
          _showErrorDialog(context, compressedImage.length);
        } else {
          setState(() {
            _selectedImage = compressedImage;
          });
          updatePicture();
          print('Ảnh đã chọn, kích thước: ${compressedImage.length} bytes');
        }
      } else {
        setState(() {
          _selectedImage = fileBytes;
        });
        updatePicture();
        print('Ảnh đã chọn, kích thước: ${fileBytes.length} bytes');
      }
    }
  }

  void _showErrorDialog(BuildContext context, int fileSize) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: Text(
            'Kích thước file quá lớn',
            style: GoogleFonts.barlow(
              fontSize: 18,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'File đã chọn có kích thước: ${fileSize} bytes.\nVui lòng chọn file nhỏ hơn 5.5KB.',
            style: GoogleFonts.barlow(
              fontSize: 18,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: subhead,
              ),
            ),
          ],
        );
      },
    );
  }
}
