import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> ordersenting({
  required String id,
  required int totalPrice,
  required List<Map<String, dynamic>> products,
}) async {
  try {
    var url = "http://143.198.61.94:8000/api/orders/";
    var detail = {
      "customer_id": id,
      "total_price": totalPrice.toString(),
      "products": jsonEncode(products), // Ensure correct JSON format
    };

    var headers = {
      'Content-Type': 'application/json', // Set content type
    };

    print('Sending data: $detail');

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(detail), // Encode the entire body to JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      print('Order sent successfully: $data');
    } else {
      print('Failed to send order. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}
