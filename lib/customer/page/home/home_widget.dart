import 'package:ecommerce_app_api/api/apicategory.dart';
import 'package:ecommerce_app_api/api/apigender.dart';
import 'package:ecommerce_app_api/api/apiproduct.dart';
import 'package:ecommerce_app_api/config/const.dart';
import 'package:ecommerce_app_api/customer/page/cart/cart_widget.dart';
import 'package:ecommerce_app_api/model/category.dart';
import 'package:ecommerce_app_api/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shopping/detail_product_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final TextEditingController _searchingController = TextEditingController();
  List<Product>? list = [];
  List<int> selectedCategoryIDs = [];
  List<Product> filteredProducts = [];
  List<Product> searchingProducts = [];
  List<Category>? listCategories = [];

  String _query = '';

  void getProduct() async {
    list = await APIProduct().GetList();
    listCategories = await APICategory().GetList();
    if (list != null) {
      for (var pro in list!) {
        pro.nameGender = await APIGender().getGender(pro.genderID!);
        pro.nameCategory = await APIGender().getCategory(pro.genderID!);
        pro.listPicture = await APIProduct().getPicturesByProduct(pro.id!);
        pro.listVariant = await APIProduct().getVariantByProduct(pro.id!);
        pro.listColor = await APIProduct().getColorByProduct(pro.id!);
        pro.listSize = await APIProduct().getSizeByProduct(pro.id!);
      }
    }
    filteredProducts = List.from(list!);
    setState(() {});
  }

  void toggleCategorySelection(int categoryID) {
    if (selectedCategoryIDs.contains(categoryID)) {
      selectedCategoryIDs.remove(categoryID);
    } else {
      selectedCategoryIDs.add(categoryID);
    }
    filterProducts();
    setState(() {});
  }

  void filterProducts() {
    if (selectedCategoryIDs.isEmpty) {
      filteredProducts = List.from(list!); // Nếu không có gì được chọn
    } else {
      filteredProducts = list!
          .where((product) => selectedCategoryIDs.contains(product.categoryID))
          .toList();
    }
    setState(() {});
  }

  void removeSelectedCategory(int? id) {
    setState(() {
      selectedCategoryIDs.remove(id);
      filterProducts();
      if (selectedCategoryIDs.isEmpty) {
        filteredProducts = List.from(list!);
      }
    });
  }

  void searching(String query) {
    // filteredProducts = List.from(list!);

    if (query != '') {
      filteredProducts = filteredProducts!
          .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredProducts = List.from(list!);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProduct();
    // filteredProducts = List.from(list!);
    // filterProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 13,
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(),
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              _query = text;
                              searching(_query);
                            });
                          },
                          // controller: _searchingController,
                          decoration: const InputDecoration(
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
                              borderSide:
                                  BorderSide(color: blackColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide:
                                  BorderSide(color: blackColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                          cursorColor: blackColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: _myFilter(),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartWidget()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart_rounded,
                            color: blackColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                selectedCategoryIDs.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedCategoryIDs.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              var category = listCategories?.firstWhere(
                                (c) => c.id == selectedCategoryIDs[index],
                              );
                              return _buildFilter(category, context);
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
                // List
                filteredProducts.isEmpty
                    ? Text(
                        "Không có sản phẩm nào",
                        style: labelGrey,
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: filteredProducts.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 12),
                        itemBuilder: (context, index) {
                          return _buildProduct(
                              filteredProducts[index], context);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProduct(Product product, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailWidget(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: greyColor,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.25),
          //     spreadRadius: 2,
          //     blurRadius: 1,
          //     offset: Offset(0, 1),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(product.listPicture!.first.image!),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const Icon(Icons.image),
                ),
              ),
              alignment: Alignment.topRight,
              child: IconButton.filledTonal(
                color: branchColor,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        product.nameGender!.name!,
                        style: GoogleFonts.barlow(
                          fontSize: 15,
                          color: greyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      product.listSize!.isEmpty
                          ? SizedBox()
                          : Text.rich(
                              TextSpan(
                                text: "${product.listSize?.first.name}-",
                                style: GoogleFonts.barlow(
                                    fontSize: 15,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: product.listSize?.last.name,
                                    style: GoogleFonts.barlow(
                                      fontSize: 15,
                                      color: greyColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    product.name.toString(),
                    style: subhead,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    NumberFormat('###,###.### đ').format(product.price),
                    style: GoogleFonts.barlow(
                      fontSize: 16,
                      color: branchColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myFilter() {
    return IconButton(
      onPressed: () {
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
                          "Hãy chọn loại sản phẩm",
                          style: GoogleFonts.barlow(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        ...listCategories!.map((category) => CheckboxListTile(
                              activeColor: branchColor,
                              title: Text(
                                category.name!,
                                style: body,
                              ),
                              value: selectedCategoryIDs.contains(category.id),
                              onChanged: (bool? isSelected) {
                                setState(() {
                                  toggleCategorySelection(category.id!);
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
      icon: Icon(Icons.sort_rounded, color: blackColor),
    );
  }

  Widget _buildFilter(Category? selectedCategory, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: greyColor,
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                selectedCategory!.name!,
                style: GoogleFonts.barlow(
                  fontSize: 12,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    removeSelectedCategory(selectedCategory.id);
                  });
                },
                icon: Icon(
                  Icons.cancel_rounded,
                  color: whiteColor,
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
}
