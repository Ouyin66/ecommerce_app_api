import 'package:ecommerce_app_api/model/cart.dart';
import 'package:flutter/material.dart';

class SelectedCart extends ChangeNotifier {
  List<Cart> lst = [];

  bool selected(Cart cart) {
    return lst.any((c) => c.id == cart.id);
  }

  void Add(Cart cart) {
    if (!selected(cart)) {
      lst.add(cart);
    }

    notifyListeners();
  }

  void Remove(Cart cart) {
    if (selected(cart)) {
      lst.removeWhere((c) => c.id == cart.id);
    }

    notifyListeners();
  }

  void Update(Cart cart) {
    var index = lst.indexWhere((c) => c.id == cart.id);
    if (index != -1) {
      lst[index].quantity = cart.quantity;
      notifyListeners();
    } else {
      print("Không tìm thấy sản phẩm với id: ${cart.id}");
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
  }
}
