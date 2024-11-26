import 'package:ecommerce_app_api/api/api_status.dart';
import 'package:ecommerce_app_api/model/order_status_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';
import '../../../model/receipt.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_avif/flutter_avif.dart';

import '../../../model/receipt_variant.dart';

class OrderTrackingWidget extends StatefulWidget {
  final Receipt receipt;
  const OrderTrackingWidget({super.key, required this.receipt});

  @override
  State<OrderTrackingWidget> createState() => _OrderTrackingWidgetState();
}

class _OrderTrackingWidgetState extends State<OrderTrackingWidget> {
  Receipt receipt = Receipt(receiptVariants: []);
  bool _isLoading = true;
  List<OrderStatusHistory> listStatus = [];

  bool isExpanded = false;
  int maxState = -1;

  Future<void> getData() async {
    var response = await APIStatus().getStatusByReceipt(widget.receipt.id!);
    if (response != null) {
      listStatus = List.from(response);
      maxState = listStatus.first.state!;
    } else {
      print("Lấy danh sách thất bại");
    }
  }

  @override
  void initState() {
    super.initState();
    receipt = widget.receipt;
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    await getData();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
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
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                  child: Column(
                    children: [
                      _buildAppBar(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildBoxMainState(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildBoxItem(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildBoxStatus(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildBoxStatus() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemCount: listStatus.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var isFirst = index == 0;
          var isLast = index == listStatus.length - 1;
          var item = listStatus[index];
          return _buildStatus(item, index, isFirst, isLast);
        },
      ),
    );
  }

  Widget _buildStatus(
      OrderStatusHistory status, int index, bool isFirst, bool isLast) {
    final DateTime dateTime = DateTime.parse(status.timestamp!);
    var formattedDate = DateFormat('dd/MM \nHH:mm').format(dateTime);

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.2, // Định vị đường timeline
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 15,
        height: 15,
        color: isFirst
            ? branchColor
            : Colors.grey, // Đổi màu cho trạng thái đầu tiên
        indicatorXY: 0.5,
      ),
      beforeLineStyle: LineStyle(
        color: index == 1 ? branchColor : Colors.grey,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isFirst ? branchColor : Colors.grey,
        thickness: 2,
      ),
      startChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          formattedDate,
          style: GoogleFonts.barlow(
            fontSize: 14,
            color: isFirst ? Colors.black : greyColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.end,
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          status.notes ?? '',
          style: GoogleFonts.barlow(
            fontSize: 16,
            color: isFirst ? Colors.black : greyColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildBoxMainState() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: maxState == 0
                ? _buildMainStateIcon(Icons.cancel_outlined, "Đã hủy", 0)
                : _buildMainStateIcon(
                    Icons.inventory_2_rounded, "Đang chuẩn bị", 1),
          ),
          _buildDividerState(2),
          Expanded(
            flex: 5,
            child: _buildMainStateIcon(
                Icons.delivery_dining_rounded, "Đang vận chuyển", 2),
          ),
          _buildDividerState(2),
          Expanded(
            flex: 5,
            child: _buildMainStateIcon(
                Icons.check_circle_outline_rounded, "Đã giao", 3),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStateIcon(
    IconData icon,
    String label,
    int id,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Material(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: maxState >= id
                    ? branchColor.withOpacity(1)
                    : greyColor.withOpacity(1),
              ),
              child: Icon(
                icon,
                color: whiteColor,
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: 12,
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDividerState(int id) {
    return Row(
      children: [
        SizedBox(
          width: 0,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 8,
            maxWidth: 45,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16),
              color: maxState >= id
                  ? branchColor.withOpacity(1)
                  : greyColor.withOpacity(1),
            ),
            child: null,
          ),
        ),
        SizedBox(
          width: 0,
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
          "Trạng thái đơn hàng",
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
            itemCount: isExpanded ? receipt.receiptVariants.length : 1,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              var item = receipt.receiptVariants[index];
              return _buildItem(item, context);
            },
          ),
          // Nút mở rộng/thu gọn danh sách
          if (receipt.receiptVariants.length > 1) ...[
            const SizedBox(height: 10),
            IconButton(
              icon: Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ]
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
        receipt.receiptVariants.last.receiptId == item.receiptId
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
      ],
    );
  }
}
