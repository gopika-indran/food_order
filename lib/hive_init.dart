import 'package:food_delivery_app/models/cart_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveData {
  static init() async {
    final appDocDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    Hive.registerAdapter(CartItemAdapter());
    await Hive.openBox<CartItem>("user");
  }
}
