import 'package:ecommerce_app_api/api/api_location.dart';
import 'package:ecommerce_app_api/model/cart.dart';
import 'package:ecommerce_app_api/model/location.dart';
import 'package:ecommerce_app_api/model/promotion.dart';
import 'package:flutter/material.dart';

class SelectedCart extends ChangeNotifier {
  List<Cart> lst = [];
  Location? selectedLocation;
  Promotion? voucher;

  void getVoucher(Promotion promo) {
    voucher = promo;
    notifyListeners();
  }

  void selectAddress(Location location) {
    selectedLocation = location;
    print(selectedLocation!.address);

    notifyListeners();
  }

  Future<void> getDefaultAddress(int locationId) async {
    var location = await APILocation().Get(locationId);

    if (location != null) {
      selectedLocation = location;
    }

    notifyListeners();
  }

  bool selected(Cart cart) {
    return lst
        .any((c) => c.variantId == cart.variantId && c.userId == cart.userId);
  }

  void Add(Cart cart) {
    if (!selected(cart)) {
      lst.add(cart);
    }

    notifyListeners();
  }

  void Remove(Cart cart) {
    if (selected(cart)) {
      lst.removeWhere(
          (c) => c.variantId == cart.variantId && c.userId == cart.userId);
    }

    notifyListeners();
  }

  void Update(Cart cart) {
    var index = lst.indexWhere(
        (c) => c.variantId == cart.variantId && c.userId == cart.userId);
    if (index != -1) {
      lst[index].quantity = cart.quantity;
      notifyListeners();
    } else {
      print(
          "Không tìm thấy sản phẩm với id: ${cart.variantId} & ${cart.userId}");
    }

    notifyListeners();
  }

  double getTotalPrice() {
    notifyListeners();
    return lst.fold(0, (sum, cart) => sum + (cart.price! * cart.quantity!));
  }

  double get totalPrice =>
      lst.fold(0, (sum, cart) => sum + (cart.price! * cart.quantity!));

  int get totalItem => lst.length;

  void MakeNull() {
    lst = [];
    selectedLocation = null;
    voucher = null;
  }

  void ClearAddress() {
    selectedLocation = null;
  }
}
