import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigtion.dart';
import 'package:food_delivery_app/models/cart_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class TestCartProvider extends ChangeNotifier {
  final Box<CartItem> cartbox = Hive.box("user");
  List<CartItem> get cartitemlists => cartbox.values.toList();
  double _totalRate = 0;

  double get totalRate => _totalRate;

  Future<Box<CartItem>> openCartBox() async {
    if (!Hive.isBoxOpen('cart')) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }
    final cartBox = await Hive.openBox<CartItem>('cart');
    print('CartBox is opened: ${cartBox.isOpen}');
    return cartBox;
  }

  Future<List<CartItem>> getCartItems() async {
    final cartBox = await openCartBox();
    final cartItems2 = cartBox.values.toList();
    print('Number of items in the cart: ${cartItems2.length}');
    for (var item in cartItems2) {
      print(
          'Item name: ${item.name}, Price: ${item.price}, Image: ${item.image}');
    }
    return cartItems2;
  }

  Future<void> decrementQuantity(CartItem item) async {
    final cartBox = await openCartBox();

    if (item.quantity > 0) {
      item.quantity--;
      if (item.quantity == 0) {
        cartBox.delete(item.key);
      } else {
        await cartBox.put(item.key, item);
      }
    }
    await _updateCartAndTotal();
  }

  Future<void> incrementQuantity(CartItem item) async {
    final cartBox = await openCartBox();

    item.quantity++;
    await cartBox.put(item.key, item);
    await _updateCartAndTotal();
  }

  double eachtotoalrate(CartItem item) {
    return item.price * item.quantity;
  }

  Future<void> _updateCartAndTotal() async {
    final cartItems = await getCartItems();
    _calculateTotal(cartItems);
    notifyListeners();
  }

  void _calculateTotal(List<CartItem> cartItems) {
    _totalRate =
        cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  getSubTotal() async {
    final cartItems = await getCartItems();

    for (var element in cartItems) {
      var item = element.price * element.quantity;
      _totalRate += item;
    }
    notifyListeners();
  }

  Future<void> removingitem(BuildContext context) async {
    final cartBox = await openCartBox();
    await cartBox.clear();
    _totalRate = 0.0;

    notifyListeners();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const navigationpage()));
  }
}
