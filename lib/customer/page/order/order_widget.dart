import 'package:ecommerce_app_api/api/api_promotion.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/page/user/location_widget.dart';
import 'package:ecommerce_app_api/customer/services/stripe_service.dart';
import 'package:ecommerce_app_api/model/cart.dart';
import 'package:ecommerce_app_api/model/location.dart';
import 'package:ecommerce_app_api/model/promotion.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../api/sharepre.dart';
import '../../../model/receipt_variant.dart';
import '../../../model/selectedcart.dart';
import '../../../model/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_avif/flutter_avif.dart';

class OrderWidget extends StatefulWidget {
  final User user;
  final List<Cart> items;
  const OrderWidget({super.key, required this.items, required this.user});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vouchercontroller = TextEditingController();
  User user = User();
  List<Cart> lst = [];
  Promotion? voucher;
  double totalItem = 0;
  double discount = 0;
  double total = 0;

  void getAddress() async {
    final selectedCart = Provider.of<SelectedCart>(context);

    if (user.defaultLocationID != 0 && selectedCart.selectedLocation == null) {
      await selectedCart.getDefaultAddress(user.defaultLocationID!);
      _addressController.text = selectedCart.selectedLocation!.address!;
    } else {
      print("null");
    }

    if (selectedCart.voucher != null) {
      discount = (selectedCart.voucher!.perDiscount! * total);
    }
  }

  void checkVoucher() async {
    if (voucher != null) {
      discount = (voucher!.perDiscount! * totalItem);
      total = totalItem - discount;
    } else {
      discount = 0;
      total = totalItem;
    }
    setState(() {});
  }

  Receipt createReceipt() {
    List<ReceiptVariant> receiptVariants = lst.map((cart) {
      return ReceiptVariant(
        variantId: cart.variantId ?? 0,
        quantity: cart.quantity ?? 0,
        price: cart.price ?? 0.0,
      );
    }).toList();

    return Receipt(
      userId: user.id,
      name: user.name,
      address: _addressController.text,
      phone: user.phone,
      discount: discount,
      paymentId: null,
      interest: false,
      total: total,
      receiptVariants: receiptVariants,
      // orderStatusHistories: [],
    );
  }

  void checkInfoUser() async {
    await updateUser(user.id!);
    user = await getUser();
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    checkInfoUser();
    lst = List.from(widget.items);
    totalItem =
        lst.fold(0, (sum, item) => sum + (item.price! * item.quantity!));
    checkVoucher();
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
              Text("Đặt hàng", style: head),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    _buildBoxLocation(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildBoxUser(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildBoxItem(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildBoxVoucher(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildBoxDetailTotal(),
                    SizedBox(
                      height: 75,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                // padding:
                //     const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Đồng bộ chiều cao
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text.rich(
                          TextSpan(
                            text: 'Tổng thanh toán\n',
                            style: GoogleFonts.barlow(
                              fontSize: 16,
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    NumberFormat('###,###.### đ').format(total),
                                style: GoogleFonts.barlow(
                                  fontSize: 24,
                                  color: branchColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var receipt = createReceipt();
                          StripeService.instance.makePayment(
                              user.name!, user.email!, receipt, context);
                        } else {
                          if (_formKey.currentState!.validate()) {
                            var receipt = createReceipt();
                            StripeService.instance.makePayment(
                                user.name!, user.email!, receipt, context);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(),
                        ),
                        backgroundColor: branchColor,
                      ),
                      child: Text(
                        "Thanh toán",
                        style: subhead,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxLocation() {
    final selectedCart = Provider.of<SelectedCart>(context);
    getAddress();
    // checkAdress();
    // if (selectedCart.selectedLocation != null) {
    //   _addressController.text = selectedCart.selectedLocation!.address!;
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              // borderRadius: BorderRadius.all(
              //   Radius.circular(26),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Địa chỉ giao hàng",
                  style: infoLabel,
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                        "Địa chỉ giao hàng",
                        Icons.location_on,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationWidget(
                                user: user,
                                selectedWidget: true,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Chọn địa điểm có sẵn",
                              style: subhead,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: blackColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        itemCount:
                            selectedCart.selectedLocation != null ? 1 : 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildSelectedAdress(
                              selectedCart.selectedLocation!, context);
                        },
                      ),
                      Text(
                        "*Nhấn vào để tự động điền vào địa chỉ giao hàng*",
                        style: GoogleFonts.barlow(
                            fontSize: 16,
                            color: greyColor,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxVoucher() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              // borderRadius: BorderRadius.all(
              //   Radius.circular(26),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Khuyến mãi",
                  style: infoLabel,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildVoucher(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoucher() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: _buildInputVoucher(),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: buildButtonVoucher(),
            ),
          ],
        ),
        voucher != null
            ? SizedBox(
                height: 15,
              )
            : SizedBox(),
        ListView.builder(
          // padding: const EdgeInsets.symmetric(vertical: 5),
          itemCount: voucher != null ? 1 : 0,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildSelectedVoucher(voucher!, context);
          },
        ),
      ],
    );
  }

  Widget _buildBoxItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              // borderRadius: BorderRadius.all(
              //   Radius.circular(26),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemCount: lst.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = lst[index];
                    return _buildItem(item, context);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Tổng tiền của sản phẩm",
                      style: subhead,
                    ),
                    Spacer(),
                    Text(
                      NumberFormat('###,###.### đ').format(totalItem),
                      style: subhead,
                      textAlign: TextAlign.end,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxUser() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thông tin người nhận",
                  style: infoLabel,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildInfoUser(Icons.person, 'Tên người đặt', user.name ?? ''),
                SizedBox(
                  height: 15,
                ),
                _buildInfoUser(Icons.phone, 'Số điện thoại', user.phone ?? ''),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoUser(IconData icon, String label, String data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: 18,
            color: blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Expanded(
          flex: 7,
          child: Text(
            data,
            style: infoLabel,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget InputField(String hintText, IconData icon, {bool isPhone = false}) {
    return TextFormField(
      controller: _addressController,
      keyboardType: isPhone ? TextInputType.number : null,
      inputFormatters: isPhone
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.barlow(
          fontSize: 16,
          color: greyColor,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        ),
        prefixIcon: Icon(
          icon,
          color: greyColor,
        ),
        iconColor: greyColor,
        border: FocusBorder(),
        focusedBorder: FocusBorder(),
        enabledBorder: EnableBorder(),
        errorBorder: ErrorBorder(),
        focusedErrorBorder: ErrorFocusBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: _addressController.value.text != '' ||
                _addressController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _addressController.clear();
                  });
                },
                icon: const Icon(Icons.cancel))
            : null,
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
      onChanged: null,
    );
  }

  Widget _buildItem(Cart item, BuildContext context) {
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
                          item.product?.name.toString() ?? '',
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
                              item.product != null
                                  ? Text.rich(
                                      TextSpan(
                                        text: "Phân loại: ",
                                        style: GoogleFonts.barlow(
                                            fontSize: 15,
                                            color: blackColor,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: item.product!.listColor
                                                ?.where((c) =>
                                                    c.id ==
                                                    item.variant!.colorID)
                                                .first
                                                .name,
                                            style: GoogleFonts.barlow(
                                                fontSize: 15,
                                                color: blackColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                                ', ${item.product!.listSize?.where((s) => s.id == item.variant!.sizeID).first.name}',
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
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildSelectedAdress(Location location, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _addressController.text = location.address!;
            });
          },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          user.defaultLocationID == location.id
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: branchColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Mặc định",
                                      style: GoogleFonts.barlow(
                                        fontSize: 16,
                                        color: branchColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            width:
                                user.defaultLocationID == location.id ? 5 : 0,
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              location.name!,
                              style: GoogleFonts.barlow(
                                fontSize: 18,
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              // maxLines: 1,
                              softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
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

  Widget _buildBoxDetailTotal() {
    // checkVoucher();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            // width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              // borderRadius: BorderRadius.all(
              //   Radius.circular(26),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chi tiết thanh toán",
                  style: infoLabel,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildItemDetailTotal("Tổng tiền hàng", totalItem),
                SizedBox(
                  height: 10,
                ),
                _buildItemDetailTotal("Giảm giá", discount, isDiscount: true),
                SizedBox(
                  height: 10,
                ),
                _buildItemDetailTotal("Tổng tiền", total, isTotal: true),
                // SizedBox(
                //   height: 15,
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetailTotal(String label, double money,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: isTotal ? 20 : 18,
            color: isDiscount ? blackColor.withOpacity(0.7) : blackColor,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            isDiscount
                ? "- ${NumberFormat('###,###.### đ').format(money)}"
                : NumberFormat('###,###.### đ').format(money),
            style: GoogleFonts.barlow(
              fontSize: isTotal ? 20 : 18,
              color: isTotal
                  ? branchColor
                  : isDiscount
                      ? blackColor.withOpacity(0.7)
                      : blackColor,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildInputVoucher() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: TextField(
        controller: _vouchercontroller,
        onChanged: (text) {
          setState(() {
            // _query = text;
            // searching(_query);
          });
        },
        decoration: InputDecoration(
          labelText: "Nhập voucher",
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
          prefixIcon: const Icon(Icons.percent_rounded),
          suffixIcon: _vouchercontroller.value.text != '' ||
                  _vouchercontroller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _vouchercontroller.clear();
                    });
                  },
                  icon: const Icon(Icons.cancel))
              : null,
        ),
        cursorColor: blackColor,
      ),
    );
  }

  Widget buildButtonVoucher() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: branchColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // shadowColor: Colors.black.withOpacity(0.5),
        // elevation: 8,
      ),
      onPressed: () async {
        if (_vouchercontroller.value.text == '' ||
            _vouchercontroller.text.isEmpty) {
          showToast(context, "Hãy nhập mã voucher vào", isError: true);
        } else {
          var response =
              await APIPromotion().GetPromotionByCode(_vouchercontroller.text);
          if (response?.promotion != null) {
            voucher = response?.promotion;
            _vouchercontroller.clear();
            checkVoucher();
            showToast(context, "Áp dụng khuyến mãi thành công");
          } else if (response?.errorMessage != null) {
            showToast(context, response!.errorMessage!, isError: true);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Text(
          "Áp dụng",
          style: subhead,
        ),
      ),
    );
  }

  Widget _buildSelectedVoucher(Promotion promotion, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: branchColor.withOpacity(0.8), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            Text(
              "Voucher ${promotion.code}",
              style: GoogleFonts.barlow(
                fontSize: 16,
                color: branchColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "- Giảm ${promotion.perDiscount! * 100}%",
              style: GoogleFonts.barlow(
                fontSize: 16,
                color: branchColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  voucher = null;
                  checkVoucher();
                });
              },
              child: Icon(
                Icons.remove_circle_rounded,
                color: branchColor.withOpacity(0.8),
              ),
            )
          ],
        ),
      ),
    );
  }
}
