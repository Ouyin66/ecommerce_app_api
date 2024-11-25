import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_app_api/api/api_cart.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/model/color.dart';
import 'package:ecommerce_app_api/model/product.dart';
import 'package:ecommerce_app_api/model/size.dart';
import 'package:ecommerce_app_api/model/variant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_avif/flutter_avif.dart';
import '../../../api/sharepre.dart';
import '../../../model/user.dart';

class ProductDetailWidget extends StatefulWidget {
  final Product product;
  const ProductDetailWidget({super.key, required this.product});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  User? user;
  int _currentIndex = 0;
  bool _isVisible = false;

  Variant? _selectedVariant;
  int? colorId;
  int? sizeId;

  int _quantity = 1;

  void getVariant() {
    _selectedVariant?.color =
        widget.product.listColor?.firstWhere((c) => c.id == colorId);

    _selectedVariant?.size = widget.product.listSize!.isEmpty
        ? null
        : widget.product.listSize?.firstWhere((s) => s.id == sizeId);

    // if (sizeId != null) {
    //   _selectedVariant = widget.product.listVariant?.firstWhere(
    //     (v) => v.colorID == colorId && v.sizeID == sizeId,
    //     orElse: () => Variant.variantEmpty(),
    //   );
    // } else {
    //   _selectedVariant = widget.product.listVariant?.firstWhere(
    //     (v) => v.colorID == colorId,
    //     orElse: () => Variant.variantEmpty(),
    //   );
    // }

    _selectedVariant = widget.product.listVariant!.firstWhere(
      (v) => v.colorID == colorId && v.sizeID == sizeId,
      orElse: () => Variant.variantEmpty(),
    );

    _currentIndex = widget.product.listPicture!.indexWhere(
      (picture) =>
          base64Encode(picture.image as List<int>) ==
          base64Encode(_selectedVariant?.picture as List<int>),
    );

    if (_currentIndex == -1) {
      _currentIndex = 0;
    }

    setState(() {});
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.product.listPicture!.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.product.listPicture!.length) %
          widget.product.listPicture!.length;
    });
  }

  void plusQuantity() {
    setState(() {
      if (_quantity < _selectedVariant!.quantity!) {
        _quantity = _quantity + 1;
      }
    });
  }

  void minusQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity = _quantity - 1;
      }
    });
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

  @override
  void initState() {
    super.initState();
    getDataUser();
    colorId = widget.product.listColor?.first.id;
    sizeId = widget.product.listSize!.isEmpty
        ? null
        : widget.product.listSize?.first.id;

    getVariant();
    print(_selectedVariant?.picture);

    _currentIndex = widget.product.listPicture!.indexWhere(
      (picture) => picture.image == _selectedVariant?.picture,
    );

    if (_currentIndex == -1) {
      _currentIndex = 0;
    }
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
              Image.asset(
                urlLogo3,
                fit: BoxFit.cover,
                height: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Text("UNIQLO", style: subhead),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 70),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: widget.product.nameGender!.name!,
                        style: categoryText,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' / ',
                            style: categoryText,
                          ),
                          TextSpan(
                              text: widget.product.nameCategory!.name!,
                              style: categoryText),
                          TextSpan(
                            text: ' / ',
                            style: categoryText,
                          ),
                          TextSpan(
                              text: widget.product.name, style: categoryText),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Hiển thị hình ảnh và các nút chuyển ảnh
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AvifImage.memory(
                          widget.product.listPicture![_currentIndex].image!,
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.memory(
                              widget.product.listPicture![_currentIndex].image!,
                              width: double.infinity,
                              height: 400,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 150),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              backgroundColor: whiteColor.withOpacity(0.6),
                            ),
                            icon: Icon(Icons.arrow_back, color: branchColor),
                            onPressed: _previousImage,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              backgroundColor: whiteColor.withOpacity(0.6),
                            ),
                            icon: Icon(Icons.arrow_forward, color: branchColor),
                            onPressed: _nextImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Thanh dấu chấm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          widget.product.listPicture!.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? branchColor
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.name.toString(),
                      style: productName,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          NumberFormat('###,###.### đ')
                              .format(widget.product.price),
                          style: textPrice,
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border_rounded,
                            color: branchColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 10,
                      thickness: 2,
                      color: greyColor,
                    ),
                    // Màu sắc sản phẩm
                    Text.rich(
                      TextSpan(
                        text: "Màu sắc:   ",
                        style: label,
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.product.listColor
                                ?.firstWhere((c) => c.id == colorId)
                                .name,
                            style: labelGrey,
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "Màu sắc",
                    //   style: label,
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 50, // Chiều cao của vùng hiển thị hình ảnh
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.listColor?.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final color = widget.product.listColor![index];

                          return _buildColor(color, context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Kích cỡ sản phẩm
                    Text.rich(
                      TextSpan(
                        text: "Kích cỡ:   ",
                        style: label,
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.product.listSize
                                ?.firstWhere((s) => s.id == sizeId)
                                .name,
                            style: labelGrey,
                          ),
                        ],
                      ),
                    ),
                    sizeId == null
                        ? SizedBox()
                        : SizedBox(
                            height: 5,
                          ),
                    sizeId == null
                        ? SizedBox()
                        : SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.listSize?.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                final size = widget.product.listSize![index];

                                return _buildSize(size, context);
                              },
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Text(
                            "Mô tả sản phẩm",
                            style: label,
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: Icon(
                              _isVisible
                                  ? Icons.arrow_left_outlined
                                  : Icons.arrow_drop_down_outlined,
                              color: blackColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 5,
                      thickness: 2,
                      color: blackColor,
                    ),
                    Visibility(
                      visible: !_isVisible,
                      child: Text(
                        widget.product.describe.toString(),
                        softWrap: true,
                        style: describe,
                      ),
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
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                // border: Border.all(color: branchColor, width: 2.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FilledButton(
                  onPressed: () {
                    _myShowBottomSheet(context);
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: blackColor,
                  ),
                  child: Text(
                    "Thêm vào giỏ",
                    style: subhead,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColor(MyColor color, BuildContext context,
      {StateSetter? stateSetter}) {
    return InkWell(
      onTap: () {
        stateSetter == null
            ? setState(() {
                colorId = color.id;
                getVariant();
              })
            : stateSetter(() {
                colorId = color.id;
                getVariant();
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
              image: isAvifFile(color.image!) != AvifFileType.unknown
                  ? MemoryAvifImage(
                      color.image!,
                    )
                  : MemoryImage(color.image!),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSize(MySize size, BuildContext context,
      {StateSetter? stateSetter}) {
    return InkWell(
      onTap: () {
        stateSetter == null
            ? setState(() {
                sizeId = size.id;
                getVariant();
              })
            : stateSetter(() {
                sizeId = size.id;
                getVariant();
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
                  _buildBoxSelectedVaraint(),
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
                          text: widget.product.listColor
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
                      itemCount: widget.product.listColor?.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final color = widget.product.listColor![index];

                        return _buildColor(color, contextSheet,
                            stateSetter: setState);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Kích cỡ sản phẩm
                  sizeId == null
                      ? SizedBox()
                      : Text.rich(
                          TextSpan(
                            text: "Kích cỡ:   ",
                            style: label20,
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.product.listSize
                                    ?.firstWhere((s) => s.id == sizeId)
                                    .name,
                                style: label20,
                              ),
                            ],
                          ),
                        ),
                  sizeId == null
                      ? SizedBox()
                      : SizedBox(
                          height: 5,
                        ),
                  sizeId == null
                      ? SizedBox()
                      : SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.listSize?.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final size = widget.product.listSize![index];

                              return _buildSize(size, contextSheet,
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
                                    minusQuantity();
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
                                  "$_quantity",
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
                                    plusQuantity();
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
                        onPressed: _selectedVariant!.quantity! == 0
                            ? null
                            : () async {
                                var addToCart = await APICart().Insert(
                                    user!.id!,
                                    _selectedVariant!.id!,
                                    _quantity,
                                    _selectedVariant!.price!);
                                if (addToCart?.successMessage != null) {
                                  print(addToCart?.successMessage);
                                  Navigator.pop(context);
                                } else {
                                  print(addToCart?.errorMessage);
                                }
                              },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: blackColor,
                        ),
                        child: Text(
                          _selectedVariant!.quantity! == 0
                              ? "Hết hàng"
                              : "Thêm vào giỏ",
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

  Widget _buildBoxSelectedVaraint() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hình ảnh
        _buildImageVariant(widget.product.listPicture![_currentIndex].image!),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name.toString(),
                style: subhead,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Tồn kho: ${_selectedVariant?.quantity}",
                style: categoryText,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageVariant(Uint8List image) {
    return AvifImage.memory(
      image,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (contextSheet, error, stackTrace) {
        return Image.memory(
          image,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.broken_image, size: 150),
        );
      },
    );
  }
}
