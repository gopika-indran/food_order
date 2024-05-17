import 'package:flutter/material.dart';

class categoriesprovider extends ChangeNotifier {
  int _selectedindex = -1;
  int get selectedindex => _selectedindex;
  set selectedindex(int index) {
    _selectedindex = index;
    notifyListeners();
  }
}
