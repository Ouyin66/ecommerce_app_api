import 'package:ecommerce_app_api/api/api_receipt.dart';
import 'package:ecommerce_app_api/customer/page/history/receipt_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../model/receipt.dart';
import '../../../model/user.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final TextEditingController _searchingcontroller = TextEditingController();
  User user = User(id: 0);
  List<Receipt> lst = [];
  List<Receipt> filteredReceipts = [];
  List<int> selectedStateList = [];
  bool _isIncrease = false;
  DateTime? selectedDate;
  var _query = '';

  final List<Map<String, dynamic>> lstState = [
    {'id': 0, 'label': 'Đã hủy', 'color': branchColor},
    {'id': 1, 'label': 'Đang xử lý', 'color': Colors.deepOrangeAccent},
    {'id': 2, 'label': 'Đang giao', 'color': Colors.redAccent},
    {'id': 3, 'label': 'Đã giao', 'color': Colors.green},
  ];

  void getDataUser() async {
    user = await getUser();
    if (user != null) {
      print("Tìm thấy user");
      getListReceipt(user.id!);
    } else {
      print("Không tìm thấy user");
    }
    setState(() {});
  }

  void getListReceipt(int userId) async {
    var response = await APIReceipt().GetListByUser(userId);
    if (response != null) {
      lst = List.from(response);
      filteredReceipts = List.from(lst);
    }

    setState(() {});
  }

  void toggleState(int stateId) {
    if (selectedStateList.contains(stateId)) {
      selectedStateList.remove(stateId);
    } else {
      selectedStateList.add(stateId);
    }
    filterReceipt();
  }

  void filterReceipt() {
    if (selectedStateList.isNotEmpty && selectedDate == null) {
      filteredReceipts = lst
          .where((receipt) => selectedStateList
              .contains(receipt.orderStatusHistories!.first.state))
          .toList();
    } else {
      filteredReceipts = List.from(lst);
    }

    if (selectedDate != null) {
      var formatted = DateFormat('dd/MM/yyyy').format(selectedDate!);

      filteredReceipts = filteredReceipts
          .where((r) => DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(r.dateCreate!))
              .toLowerCase()
              .contains(formatted.toString().toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  void searching(String query) {
    if (query != '') {
      filterReceipt();
      filteredReceipts = filteredReceipts
          .where((r) =>
              r.address!.toLowerCase().contains(query.toLowerCase()) ||
              r.phone!.toLowerCase().contains(query.toLowerCase()) ||
              r.dateCreate!.toLowerCase().contains(query.toLowerCase()) ||
              "HD${r.id.toString().padLeft(10, '0')}"
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      filterReceipt();
    }

    setState(() {});
  }

  void removeSelectedState(int selectedState) {
    selectedStateList.remove(selectedState);
    filterReceipt();
    if (selectedStateList.isEmpty) {
      filteredReceipts = List.from(lst);
    }
    setState(() {});
  }

  void soft() {
    if (_isIncrease) {
      filteredReceipts.sort((a, b) => DateTime.parse(a.dateCreate!)
          .compareTo(DateTime.parse(b.dateCreate!)));
    } else {
      filteredReceipts.sort((a, b) => DateTime.parse(b.dateCreate!)
          .compareTo(DateTime.parse(a.dateCreate!)));
    }

    setState(() {});
  }

  void isInterest(int receiptId, bool isInterest) async {
    var response = await APIReceipt().updateInterest(receiptId, isInterest);
    if (response?.successMessage != null) {
      getListReceipt(user.id!);
    } else {
      print("Lỗi cập nhật trường Interest cho Receipt ");
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              _buildSearchBox(),
              SizedBox(height: 10),
              selectedStateList.isNotEmpty
                  ? SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedStateList.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildFilter(
                                selectedStateList[index], context);
                          },
                        ),
                      ),
                    )
                  : SizedBox(),
              selectedDate != null ? _buildDate() : SizedBox(),
              SizedBox(height: 10),
              _buildLabel(),
              _buildList(filteredReceipts),
              SizedBox(
                height: 75,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Lịch sử đơn hàng',
            style: GoogleFonts.barlow(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              setState(() {
                _isIncrease = !_isIncrease;
                soft();
              });
            },
            child: Icon(
              _isIncrease
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 24,
              color: blackColor,
            ),
          )
        ],
      );

  Widget _buildList(List<Receipt> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: list.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        var item = list[index];
        return _buildReceipt(item, context);
      },
    );
  }

  Widget _buildReceipt(Receipt item, BuildContext context) {
    DateTime dateTime = DateTime.parse(item.dateCreate!);
    var formattedDate = DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);

    var state = lstState[item.orderStatusHistories?.first.state! ?? 0];
    Color stateColor = state['color'];

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiptDetailWidget(
                    receipt: item,
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.tag_rounded),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "HD${item.id.toString().padLeft(10, '0')}",
                      style: GoogleFonts.barlow(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      decoration: BoxDecoration(
                        color: stateColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        state['label'],
                        style: GoogleFonts.barlow(
                          fontSize: 16,
                          color: stateColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        if (item.interest!) {
                          isInterest(item.id!, false);
                        } else {
                          isInterest(item.id!, true);
                        }
                      },
                      child: Icon(
                        item.interest!
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none,
                        color: branchColor,
                      ),
                    ),
                  ],
                ),
                _buildInfo(
                  Icons.date_range_rounded,
                  formattedDate.toString(),
                ),
                _buildInfo(
                  Icons.contact_phone_outlined,
                  "${user.name} | ${item.phone}",
                ),
                _buildInfo(
                  Icons.location_on_outlined,
                  item.address.toString(),
                ),
                Divider(),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Tổng tiền ",
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "(${item.totalItem} sản phẩm)",
                            style: GoogleFonts.barlow(
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    Text(
                      NumberFormat('###,###.### đ').format(item.total ?? 0),
                      style: GoogleFonts.barlow(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String information) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        SizedBox(
          width: 5,
        ),
        Text(
          information,
          style: GoogleFonts.barlow(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          flex: 13,
          child: _buildSearching(),
        ),
        Spacer(),
        Expanded(
          flex: 2,
          child: _myFilter(),
        ),
        Spacer(),
        Expanded(flex: 2, child: _myPickerDate())
      ],
    );
  }

  Widget _buildSearching() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(),
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
          labelStyle: TextStyle(color: blackColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(color: blackColor, width: 2),
          ),
          prefixIcon: Icon(Icons.search_rounded),
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

  Widget _myFilter() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Chọn trạng thái hóa đơn",
                          style: GoogleFonts.barlow(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        ...lstState.map((state) => CheckboxListTile(
                              activeColor: branchColor,
                              title: Text(
                                state['label'],
                                style: body,
                              ),
                              value: selectedStateList.contains(state['id']),
                              onChanged: (bool? isSelected) {
                                print(state['id']);
                                setState(() {
                                  toggleState(state['id']);
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Icon(
        Icons.sort_rounded,
        color: blackColor,
        size: 30,
      ),
    );
  }

  Widget _myPickerDate() {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          locale: Locale('vi'), // Hiển thị tiếng Việt
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: branchColor, // Màu chính
                  onPrimary: Colors.white, // Màu chữ trên nút
                  surface: whiteColor, // Màu nền ngày được chọn
                  onSurface: Colors.black, // Màu chữ trong picker
                ),
                textTheme: TextTheme(
                  headlineSmall: GoogleFonts.barlow(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ), // Tiêu đề (vd: "Chọn ngày")
                  bodyMedium: GoogleFonts.barlow(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ), // Ngày trong bảng lịch
                  labelLarge: GoogleFonts.barlow(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ), // Nút OK/Hủy
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: branchColor,
                    textStyle: GoogleFonts.barlow(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          // Lưu ngày được chọn và cập nhật trạng thái
          setState(() {
            selectedDate = pickedDate;
          });
        }

        filterReceipt();
      },
      child: Icon(
        Icons.calendar_month_outlined,
        size: 30,
      ),
    );
  }

  Widget _buildFilter(int selectedState, BuildContext context) {
    var state = lstState[selectedState];
    Color color = state['color'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            // border: Border.all(color: greyColor),
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state['label'],
                style: GoogleFonts.barlow(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    removeSelectedState(selectedState);
                  });
                },
                child: Icon(
                  Icons.cancel_rounded,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: branchColor,
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(selectedDate!),
                style: GoogleFonts.barlow(
                  fontSize: 12,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = null;
                    filterReceipt();
                  });
                },
                child: Icon(
                  Icons.cancel_rounded,
                  color: whiteColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
