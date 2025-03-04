import 'package:fake_store_app/models/cart_item.dart';
import 'package:flutter/widgets.dart';

import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
    0.0,
    (total, current) => total + current.product.price * current.quantity,
  );

  int get itemCount =>
      _items.fold(0, (total, current) => total + current.quantity);

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      _items.add(CartItem(product: product, quantity: quantity));
    } else {
      _items[index] = _items[index].copyWith(
        newQuantity: _items[index].quantity + quantity,
      );
    }

    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != 1) {
      _items[index] = _items[index].copyWith(newQuantity: quantity);
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
