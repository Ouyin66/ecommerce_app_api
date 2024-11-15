import 'package:ecommerce_app_api/api/apicart.dart';
import 'package:ecommerce_app_api/api/apicolor.dart';
import 'package:ecommerce_app_api/api/apiproduct.dart';
import 'package:ecommerce_app_api/api/apisize.dart';
import 'package:ecommerce_app_api/api/apivariant.dart';
import 'package:ecommerce_app_api/customer/page/order/order_widget.dart';
import 'package:ecommerce_app_api/model/variant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../api/sharepre.dart';
import '../../../config/const.dart';
import '../../../model/cart.dart';
import '../../../model/color.dart';
import '../../../model/selectedcart.dart';
import '../../../model/size.dart';
import '../../../model/user.dart';
import 'package:intl/intl.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  User user = User.userEmpty();
  List<Cart>? list = [];
  Variant _selectedVariant = Variant.variantEmpty();
  int? colorId;
  int? sizeId;
  int? _quantity;

  void getVariant(Cart cart) async {
    _selectedVariant.color =
        cart.product?.listColor?.firstWhere((c) => c.id == colorId);

    _selectedVariant.size = cart.product?.listSize != []
        ? null
        : cart.product?.listSize?.firstWhere((s) => s.id == sizeId);

    if (sizeId != null) {
      _selectedVariant = cart.product!.listVariant!.firstWhere(
        (v) => v.colorID == colorId && v.sizeID == sizeId,
        orElse: () => Variant.variantEmpty(),
      );
    } else {
      _selectedVariant = cart.product!.listVariant!.firstWhere(
        (v) => v.colorID == colorId,
        orElse: () => Variant.variantEmpty(),
      );
    }

    setState(() {});
  }

  Future<void> getList(int id) async {
    list = await APICart().getCartByUser(id);
    if (list != null) {
      for (var cart in list!) {
        cart.variant = await APIVariant().getVariant(cart.variantId!);
        cart.product = await APIProduct().getProduct(cart.variant!.productID!);
        if (cart.product != null) {
          cart.product?.listColor =
              await APIColor().getColorByProduct(cart.product!.id!);
          cart.product?.listSize =
              await APISize().getSizeByProduct(cart.product!.id!);
          cart.product?.listVariant =
              await APIVariant().getVariantByProduct(cart.product!.id!);
        }
      }
    }
    setState(() {});
  }

  void getDataUser() async {
    user = await getUser();
    if (user != null) {
      print("Tìm thấy user");
      getList(user.id!);
    } else {
      print("Không tìm thấy user");
    }
    setState(() {});
  }

  void reload() {
    Navigator.pop(context);
    getList(user.id!);
  }

  void minus(Cart cart) async {
    var selectedCart = Provider.of<SelectedCart>(context, listen: false);

    if (cart.quantity! > 1 && cart.quantity! < cart.variant!.quantity!) {
      var response = await APICart().updateCart(cart.id!, cart.userId!,
          cart.variant!.id!, cart.quantity! - 1, cart.price!);
      if (response?.successMessage != null) {
        await getList(user.id!);
        if (selectedCart.selected(response!.cart!)) {
          selectedCart.Update(response.cart!);
        }
      } else {
        print(response?.errorMessage);
      }
    } else {
      showDeleteDialog(context, cart);
    }
    setState(() {});
  }

  void plus(Cart cart) async {
    var selectedCart = Provider.of<SelectedCart>(context, listen: false);

    if (cart.quantity! < 3 && cart.quantity! < cart.variant!.quantity!) {
      var response = await APICart().updateCart(cart.id!, cart.userId!,
          cart.variant!.id!, cart.quantity! + 1, cart.price!);
      if (response?.successMessage != null) {
        await getList(user.id!);
        if (selectedCart.selected(response!.cart!)) {
          selectedCart.Update(response.cart!);
        }
      } else {
        print(response?.errorMessage);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
    Provider.of<SelectedCart>(context, listen: false).MakeNull();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCart = Provider.of<SelectedCart>(context);

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
              Text("Giỏ hàng", style: head),
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
      body: SizedBox.expand(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      list == null || list!.isEmpty
                          ? Center(
                              child: Text(
                                "Chưa có sản phẩm nào trong giỏ",
                                style: labelGrey,
                              ),
                            )
                          : ListView.builder(
                              itemCount: list?.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = list?[index];
                                return _buildCart(item!, context);
                              },
                            ),
                      SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 10,
              right: 10,
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            border: Border.all(
                              color: blackColor,
                              width: 2,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${selectedCart.totalItem}",
                              style: head,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Tổng tiền",
                              style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  color: blackColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              NumberFormat('###,###.### đ')
                                  .format(selectedCart.totalPrice),
                              style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: FilledButton(
                          onPressed: () {
                            if (selectedCart.lst.isEmpty) {
                              showToast(context, "Hãy chọn sản phẩm muốn đặt",
                                  isError: true);
                            } else {
                              selectedCart.ClearAddress();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderWidget(
                                    items: selectedCart.lst,
                                    user: user,
                                  ),
                                ),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: blackColor,
                          ),
                          child: Text(
                            "Đặt hàng",
                            style: subhead,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart(Cart item, BuildContext context) {
    return Consumer<SelectedCart>(builder: (context, value, child) {
      return Column(
        children: [
          Container(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (value.selected(item)) {
                                value.Remove(item);
                              } else {
                                value.Add(item);
                              }
                            },
                            icon: !value.selected(item)
                                ? Icon(Icons.check_box_outline_blank_outlined)
                                : Icon(
                                    Icons.check_box,
                                    color: branchColor,
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: greyColor.withOpacity(0.3)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              image: DecorationImage(
                                image:
                                    NetworkImage(item.variant?.picture ?? ''),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                            InkWell(
                              onTap: () {
                                _myShowBottomSheet(item, context);
                              },
                              child: Container(
                                // width: double.minPositive,
                                padding: EdgeInsets.only(left: 10, right: 5),
                                decoration: BoxDecoration(
                                  color: greyColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  border:
                                      Border.all(width: 0.1, color: blackColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    item.product != null
                                        ? Text.rich(
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
                                              children: <TextSpan>[
                                                item.product?.listSize ==
                                                            null ||
                                                        item.product!.listSize!
                                                            .isEmpty
                                                    ? TextSpan()
                                                    : TextSpan(
                                                        text:
                                                            ', ${item.product!.listSize?.where((s) => s.id == item.variant!.sizeID).first.name}',
                                                        style:
                                                            GoogleFonts.barlow(
                                                          fontSize: 15,
                                                          color: blackColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: blackColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              NumberFormat('###,###.### đ')
                                  .format(item.variant?.price ?? 0),
                              style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 15,
                                          onPressed: () {
                                            setState(() {
                                              minus(item);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove_rounded,
                                          ),
                                        ),
                                        Container(
                                          height: 15,
                                          child: VerticalDivider(
                                            width: 1,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 40,
                                          child: Text(
                                            item.quantity.toString(),
                                            style: GoogleFonts.barlow(
                                              fontSize: 15,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 15,
                                          child: VerticalDivider(
                                            width: 1,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 15,
                                          onPressed: () {
                                            setState(() {
                                              plus(item);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  height: 35,
                                  child: IconButton(
                                    onPressed: () {
                                      showDeleteDialog(context, item);
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: branchColor,
                                    ),
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }

  Widget _buildColor(Cart cart, MyColor color, BuildContext context,
      {StateSetter? stateSetter}) {
    return InkWell(
      onTap: () {
        stateSetter == null
            ? setState(() {
                colorId = color.id;
                getVariant(cart);
              })
            : stateSetter(() {
                colorId = color.id;
                getVariant(cart);
              });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: colorId == color.id
                ? Border.all(
                    width: 4,
                    color: greyColor,
                  )
                : null,
            image: DecorationImage(
              image: NetworkImage(color.image!),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSize(Cart cart, MySize size, BuildContext context,
      {StateSetter? stateSetter}) {
    return InkWell(
      onTap: () {
        stateSetter == null
            ? setState(() {
                sizeId = size.id;
                getVariant(cart);
              })
            : stateSetter(() {
                sizeId = size.id;
                getVariant(cart);
              });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 50,
          width: size.name!.length > 2 ? 70 : 50,
          decoration: BoxDecoration(
            color: sizeId == size.id ? greyColor : null,
            border: sizeId == size.id
                ? Border.all(
                    width: 4,
                    color: greyColor,
                  )
                : Border.all(
                    width: 2,
                    color: blackColor,
                  ),
          ),
          child: Center(
            child: Text(
              size.name.toString(),
              style: GoogleFonts.barlow(
                color: sizeId == size.id ? whiteColor : blackColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _myShowBottomSheet(Cart cart, BuildContext context) {
    setState(() {
      _selectedVariant = cart.variant!;
      colorId = _selectedVariant.colorID;
      _quantity = cart.quantity;
      if (_selectedVariant.sizeID != null) {
        sizeId = _selectedVariant.sizeID;
      }
    });

    var selectedCart = Provider.of<SelectedCart>(context, listen: false);
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          image: DecorationImage(
                            image: NetworkImage(_selectedVariant.picture!),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 80,
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
                              cart.product!.name.toString(),
                              style: subhead,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Tồn kho: ${_selectedVariant.quantity}",
                              style: categoryText,
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
                  Text.rich(
                    TextSpan(
                      text: "Màu sắc:   ",
                      style: label20,
                      children: <TextSpan>[
                        TextSpan(
                          text: cart.product?.listColor
                              ?.firstWhere((c) => c.id == colorId)
                              .name,
                          style: label20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cart.product?.listColor?.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final color = cart.product!.listColor![index];

                        return _buildColor(cart, color, contextSheet,
                            stateSetter: setState);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Kích cỡ sản phẩm
                  cart.product!.listSize == null
                      ? SizedBox()
                      : Text.rich(
                          TextSpan(
                            text: "Kích cỡ:   ",
                            style: label20,
                            children: <TextSpan>[
                              cart.product!.listSize!.isEmpty
                                  ? TextSpan()
                                  : TextSpan(
                                      text: cart.product?.listSize
                                          ?.firstWhere((s) => s.id == sizeId)
                                          .name,
                                      style: label20,
                                    ),
                            ],
                          ),
                        ),
                  cart.product!.listSize == null
                      ? SizedBox()
                      : SizedBox(
                          height: 5,
                        ),
                  cart.product!.listSize == null
                      ? SizedBox()
                      : SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cart.product?.listSize?.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final size = cart.product!.listSize![index];

                              return _buildSize(cart, size, contextSheet,
                                  stateSetter: setState);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Số lượng",
                          style: label20,
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_quantity! > 1) {
                                      _quantity = _quantity! - 1;
                                    }
                                  });
                                },
                                icon: Icon(Icons.remove_rounded),
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey,
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.center,
                                width: 40,
                                child: Text(
                                  _quantity.toString(),
                                  style: subhead,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_quantity! < 3 &&
                                        _quantity! <
                                            _selectedVariant.quantity!) {
                                      _quantity = _quantity! + 1;
                                    }
                                  });
                                },
                                icon: Icon(Icons.add_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: FilledButton(
                        onPressed: _selectedVariant.quantity! == 0
                            ? null
                            : () async {
                                var response = await APICart().updateCart(
                                    cart.id!,
                                    user.id!,
                                    _selectedVariant.id!,
                                    _quantity!,
                                    _selectedVariant.price!);
                                if (response?.successMessage != null) {
                                  print(response?.successMessage);
                                  reload();
                                  var existing =
                                      list?.firstWhere((c) => c.id == cart.id);
                                  if (list!.contains(existing)) {
                                    if (selectedCart.selected(cart)) {
                                      selectedCart.Remove(cart);
                                      selectedCart.Update(response!.cart!);
                                    }
                                  } else {
                                    if (selectedCart
                                        .selected(response!.cart!)) {
                                      selectedCart.Update(response.cart!);
                                    }
                                  }
                                } else {
                                  print(response?.errorMessage);
                                }
                              },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: blackColor,
                        ),
                        child: Text(
                          "Cập nhật giỏ hàng",
                          style: subhead,
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  void showDeleteDialog(BuildContext context, Cart cart) {
    var selectedCart = Provider.of<SelectedCart>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          title: Text(
            "Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?",
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
              onPressed: () async {
                var response = await APICart().deleteCart(cart.id!);
                if (response?.successMessage != null) {
                  if (selectedCart.selected(cart)) {
                    selectedCart.Remove(cart);
                  }
                  reload();
                } else {
                  print(response?.errorMessage);
                }
                setState(() {});
              },
              child: Text("Xóa", style: subhead),
            ),
          ],
        );
      },
    );
  }
}
