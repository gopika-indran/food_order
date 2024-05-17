import 'package:flutter/material.dart';
import 'package:food_delivery_app/discovery_clss.dart';

class likeprovider extends ChangeNotifier {
  List<bool> likedproduct = List.generate(2, (index) => false);
  void favicon({required int index}) {
    likedproduct[index] = !likedproduct[index];
    notifyListeners();
  }
}
