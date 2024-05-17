import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/cart_model.dart';
import 'package:food_delivery_app/models/product_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class productprovider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  double _totalRate = 0.0;
  List<CartItem> get cartItems => _cartItems;
  double get totalRate => _totalRate;

  Future<void> addToCart(productmodel product) async {
    final cartBox = await openCartBox();
    bool found = false;

    for (var item in cartBox.values) {
      if (item.id == product.id) {
        item.quantity++;
        found = true;
        break;
      }
    }
    if (!found) {
      final cartItem = CartItem(
        id: product.id,
        name: product.name,
        image: product.image,
        price: product.price.toDouble(),
        quantity: 1,
      );
      cartBox.add(cartItem);
    }

    _totalRate = 0.0;
    for (var item in cartBox.values) {
      _totalRate += item.price * item.quantity;
    }

    notifyListeners();
  }

  Future<Box<CartItem>> openCartBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    return await Hive.openBox<CartItem>('cart');
  }

  List<int> additem = List.generate(100, (index) => 1);
  bool clicked = false;
  void incrementitem({required int index}) {
    int i = 1;
    i++;
    additem[index] = i;
    clicked = true;
    notifyListeners();
  }

  List<bool> addeditems = List.generate(100, (index) => false);
  void itemschange({required int index}) {
    addeditems[index] = !addeditems[index];
    notifyListeners();
  }
}
