import 'dart:convert';

import 'package:http/http.dart';

fetchcustomer(String search) async {
  try {
    var url = "http://143.198.61.94:8000/api/customers/?search_query=$search";
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body);
      return body;
    }
  } catch (e) {
    print(e.toString());
  }
}
