import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class customerprovider extends ChangeNotifier {
  TextEditingController searchcontroller = TextEditingController();

  String value = "";
  searchfield(v) async {
    value = searchcontroller.text;
    notifyListeners();
  }

  Future<void> setCustomerId(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customer_id', customerId);
    notifyListeners();
  }
}
