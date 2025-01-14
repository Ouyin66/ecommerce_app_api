import 'package:ecommerce_app_api/api/api_variant.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:ecommerce_app_api/model/receipt_variant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../api/api_status.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../main.dart';
import '../../../model/user.dart';
import 'order_tracking_widget.dart';
import 'package:flutter_avif/flutter_avif.dart';

class ReceiptDetailWidget extends StatefulWidget {
  final Receipt receipt;
  const ReceiptDetailWidget({super.key, required this.receipt});

  @override
  State<ReceiptDetailWidget> createState() => _ReceiptDetailWidgetState();
}

class _ReceiptDetailWidgetState extends State<ReceiptDetailWidget>
    with RouteAware {
  Receipt receipt = Receipt(id: 0, receiptVariants: []);
  User user = User(id: 0);

  bool _isLoading = true;

  final List<Map<String, dynamic>> lstState = [
    {'id': 0, 'label': 'Đã hủy', 'color': branchColor},
    {'id': 1, 'label': 'Đang xử lý', 'color': Colors.deepOrangeAccent},
    {'id': 2, 'label': 'Đang giao', 'color': Colors.pink},
    {'id': 3, 'label': 'Đã giao', 'color': Colors.green},
  ];

  //"HD${receipt?.id.toString().padLeft(10, '0')}"
  void getDataUser() async {
    user = await getUser();
    print("Tìm thấy user");
    setState(() {});
  }

  Future<void> getVariantReceipt() async {
    for (var variantReceipt in receipt.receiptVariants) {
      var response = await APIVariant().Get(variantReceipt.variantId!);
      if (response != null) {
        variantReceipt.variant = response;
      } else {
        print("Không tìm thấy");
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
    receipt = widget.receipt;
    _initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      MainApp.routeObserver.subscribe(this, route);
    }
    _initializeData();
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {}

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });

    await getVariantReceipt();

    setState(() {
      _isLoading = false; // Tải xong
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor.withOpacity(0.97),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.7],
                colors: [
                  branchColor.withOpacity(0.84),
                  whiteColor.withOpacity(0.97),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _isLoading
                ? LoadingScreen()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        _buildAppBar(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildBoxDetail(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildBoxInfoUser(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildBoxItem(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxDetail() {
    DateTime dateTime = DateTime.parse(receipt.dateCreate!);
    var formattedDate = DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBoxTotal(),
          SizedBox(
            height: 20,
          ),
          _buildInfo("Trạng thái", "", true),
          SizedBox(
            height: 10,
          ),
          _buildInfo(
              "Mã hóa đơn", "HD${receipt.id.toString().padLeft(10, '0')}"),
          SizedBox(
            height: 10,
          ),
          _buildInfo("Thời gian", formattedDate),
          SizedBox(
            height: 10,
          ),
          _buildInfo("Mã giao dịch", receipt.paymentId.toString()),
          receipt.discount != 0
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(),
          receipt.discount != 0
              ? _buildInfo("Giảm giá",
                  "- ${NumberFormat('###,###.### đ').format(receipt.discount)}")
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildButtonState(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String data, [bool isState = false]) {
    var state = lstState[receipt.orderStatusHistories?.first.state! ?? 0];
    Color stateColor = state['color'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: GoogleFonts.barlow(
              fontSize: 18,
              color: blackColor.withOpacity(0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 7,
          child: isState
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderTrackingWidget(
                                receipt: receipt,
                              )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: BoxDecoration(
                          color: stateColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          state['label'],
                          style: GoogleFonts.barlow(
                            fontSize: 18,
                            color: stateColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: blackColor,
                        size: 20,
                      ),
                    ],
                  ),
                )
              : Text(
                  data,
                  style: GoogleFonts.barlow(
                    fontSize: 18,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: blackColor.withOpacity(0.3),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: whiteColor,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Chi tiết hóa đơn",
          style: GoogleFonts.barlow(
            fontSize: 20,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildBoxTotal() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.green, size: 70),
          SizedBox(
            width: 10,
          ),
          Text.rich(
            TextSpan(
              text: 'Tổng tiền đã thanh toán\n',
              style: GoogleFonts.barlow(
                fontSize: 16,
                color: blackColor,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: NumberFormat('###,###.### đ').format(receipt.total),
                  style: GoogleFonts.barlow(
                    fontSize: 30,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildBoxInfoUser() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfo("Người đặt", user.name.toString()),
          SizedBox(
            height: 10,
          ),
          _buildInfo("Số điện thoại", receipt.phone.toString()),
          SizedBox(
            height: 10,
          ),
          _buildInfo("Địa chỉ", receipt.address.toString()),
        ],
      ),
    );
  }

  Widget _buildBoxItem() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemCount: receipt.receiptVariants.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              var item = receipt.receiptVariants[index];
              return _buildItem(item, context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ReceiptVariant item, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: greyColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      image: DecorationImage(
                        image: isAvifFile(item.variant!.picture!) !=
                                AvifFileType.unknown
                            ? MemoryAvifImage(
                                item.variant!.picture!,
                              )
                            : MemoryImage(item.variant!.picture!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.variant?.product?.name.toString() ?? '',
                          style: subhead,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // width: double.minPositive,
                          padding: EdgeInsets.only(left: 10, right: 5),
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            border: Border.all(width: 0.1, color: blackColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              item.variant?.color != null
                                  ? Text.rich(
                                      TextSpan(
                                        text: item.variant?.color?.name ?? '',
                                        style: GoogleFonts.barlow(
                                            fontSize: 15,
                                            color: blackColor,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          // TextSpan(
                                          //   text:
                                          //       item.variant?.color?.name ?? '',
                                          //   style: GoogleFonts.barlow(
                                          //       fontSize: 15,
                                          //       color: blackColor,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                          item.variant?.size == null
                                              ? TextSpan()
                                              : TextSpan(
                                                  text:
                                                      ', ${item.variant?.size?.name ?? ''}',
                                                  style: GoogleFonts.barlow(
                                                    fontSize: 15,
                                                    color: blackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              NumberFormat('###,###.### đ')
                                  .format(item.variant?.price ?? 0),
                              style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              'x${item.quantity.toString()}',
                              style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (receipt.receiptVariants.last.variantId != item.variantId) ...[
          SizedBox(
            height: 10,
          ),
          Divider(
            indent: 50,
            endIndent: 50,
            color: greyColor.withOpacity(0.5),
          ),
          SizedBox(
            height: 10,
          ),
        ]
      ],
    );
  }

  Widget _buildButtonState(BuildContext context) {
    var mainSate = receipt.orderStatusHistories!.first.state!;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        overlayColor: branchColor,
        foregroundColor: branchColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
            color: mainSate > 1 || mainSate == 0 ? greyColor : branchColor),
      ),
      onPressed: mainSate > 1 || mainSate == 0
          ? null
          : () {
              showDeleteDialog(context);
            },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Hủy đơn hàng",
          style: subhead,
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          title: Text(
            "Bạn có chắc muốn hủy đơn hàng này?",
            style: GoogleFonts.barlow(
              fontSize: 24,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
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
              onPressed: () async {
                var response = await APIStatus().Cancel(receipt.id!);
                if (response?.status == null) {
                  showToast(context, "Hủy đơn hàng thành công");
                  Navigator.of(context).pop();
                }
                setState(() {});
              },
              child: Text("Xác nhận", style: subhead),
            ),
          ],
        );
      },
    );
  }
}
