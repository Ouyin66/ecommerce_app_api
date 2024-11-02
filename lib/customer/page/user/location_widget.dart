import 'package:ecommerce_app_api/api/apilocation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/const.dart';
import '../../../model/location.dart';
import '../../../model/user.dart';

class LocationWidget extends StatefulWidget {
  final User user;
  const LocationWidget({super.key, required this.user});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchingcontroller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? errorMessage;
  String? anotherError;
  bool _isEdit = false;

  int? _idLocation;

  int? userId;
  List<Location>? list = [];
  List<Location>? searchingList = [];
  String _query = '';

  void getList() async {
    list = await APILocation().getLocationByUser(userId!);
    if (list != null) {
      searchingList = List.from(list!);
      print("Lấy được danh sách");
    } else {
      print("Lỗi lấy địa điểm");
    }
    setState(() {});
  }

  void searching(String query) {
    if (query != '') {
      searchingList = list!
          .where((l) =>
              l.address!.toLowerCase().contains(query.toLowerCase()) ||
              l.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchingList = List.from(list!);
    }
    setState(() {});
  }

  void add() async {
    Location location = Location(
        userId: userId,
        name: _nameController.text,
        address: _addressController.text);

    var response = await APILocation().insertLocation(location);

    setState(() {
      errorMessage = null;
      anotherError = null;

      if (response?.successMessage != null) {
        _nameController.clear();
        _addressController.clear();
        getList();
        showToast(context, response!.successMessage!);
      } else if (response?.errorMessage != null) {
        errorMessage = response!.errorMessage;
        _formKey.currentState!.validate();
      } else if (response?.anotherError != null) {
        anotherError = response!.anotherError;
        _formKey.currentState!.validate();
      }
    });
  }

  void edit() async {
    var response = await APILocation().updateLocation(
        _idLocation!, _nameController.text, _addressController.text);

    setState(() {
      errorMessage = null;
      anotherError = null;

      if (response?.successMessage != null) {
        getList();
        showToast(context, response!.successMessage!);
      } else if (response?.errorMessage != null) {
        errorMessage = response!.errorMessage;
      } else if (response?.anotherError != null) {
        anotherError = response!.anotherError;
      }

      _formKey.currentState!.validate();
    });
  }

  void delete(int id) async {
    var response = await APILocation().deleteCart(id);

    if (response?.successMessage != null) {
      getList();
      Navigator.pop(context);
      _nameController.clear();
      _addressController.clear();
      showToast(context, response!.successMessage!);
    } else if (response?.errorMessage != null) {
      showToast(context, response!.errorMessage!, isError: true);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    userId = widget.user.id;
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor.withOpacity(0.97),
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Địa chỉ giao hàng", style: head),
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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildSearching(),
                SizedBox(
                  height: 15,
                ),
                _buildAddBox(),
                SizedBox(
                  height: 15,
                ),
                searchingList == null
                    ? Center(
                        child: Text(
                          "Chưa có địa chỉ giao hàng nào",
                          style: labelGrey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchingList?.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = searchingList?[index];
                          return _buildLocation(item!, context);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocation(Location location, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(width: 0.1, color: greyColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name!,
                        style: label,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              location.address!,
                              style: GoogleFonts.barlow(
                                fontSize: 16,
                                color: greyColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEdit = true;
                      _idLocation = location.id;
                      _nameController.text = location.name!;
                      _addressController.text = location.address!;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: blackColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_isEdit = true && _idLocation == location.id) {
                      showToast(context, "Hãy hủy chỉnh sửa trước khi xóa",
                          isError: true);
                    } else {
                      showDeleteDialog(context, location.id!);
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: branchColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildSearching() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: TextField(
        controller: _searchingcontroller,
        onChanged: (text) {
          setState(() {
            _query = text;
            searching(_query);
          });
        },
        decoration: InputDecoration(
          labelText: "Tìm kiếm...",
          labelStyle: const TextStyle(color: blackColor),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor, width: 2),
          ),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _query != ''
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchingcontroller.clear();
                      _query = '';
                      searching(_query);
                    });
                  },
                  icon: const Icon(Icons.cancel))
              : null,
        ),
        cursorColor: blackColor,
      ),
    );
  }

  Widget _buildAddBox() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 0.1, color: greyColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit ? "Chỉnh sửa địa chỉ giao hàng" : "Thêm địa chỉ giao hàng",
            style: infoLabel,
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildInput(
                  _nameController,
                  "Tên địa chỉ",
                  Icons.tag_rounded,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống thông tin';
                    } else if (errorMessage != null) {
                      return errorMessage;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildInput(
                  _addressController,
                  "Địa chỉ",
                  Icons.location_on,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống thông tin';
                    } else if (anotherError != null) {
                      return anotherError;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: buildButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label,
      IconData icon, String? Function(String?) errorMess) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      obscureText: false,
      decoration: InputDecoration(
        labelText: label,
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
        errorStyle: error,
        prefixIcon: Icon(icon),
      ),
      validator: errorMess,
      onChanged: null,
    );
  }

  Widget buildButton() {
    return Row(
      children: [
        _isEdit
            ? Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: branchColor,
                      style: BorderStyle.solid,
                    ),
                    foregroundColor: branchColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isEdit = !_isEdit;
                      _idLocation = null;
                      _nameController.clear();
                      _addressController.clear();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Hủy chỉnh sửa",
                      style: subhead,
                    ),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(
          width: _isEdit ? 10 : 0,
        ),
        Expanded(
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
                if (_isEdit) {
                  edit();
                } else {
                  add();
                }
              } else if (errorMessage != null || anotherError != null) {
                if (_isEdit) {
                  edit();
                } else {
                  add();
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                _isEdit ? "Chỉnh sửa" : "Thêm địa chỉ",
                style: subhead,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          title: Text(
            "Bạn có chắc muốn xóa địa chỉ giao hàng này?",
            style: infoLabel,
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Hủy",
                style: subhead,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: branchColor,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                print(_isEdit);
                delete(id);
              },
              child: Text("Xóa", style: subhead),
            ),
          ],
        );
      },
    );
  }
}
