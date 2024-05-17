import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigtion.dart';
import 'package:food_delivery_app/hive_init.dart';
import 'package:food_delivery_app/provider/categoriespro.dart';
import 'package:food_delivery_app/provider/customer_provider.dart';
import 'package:food_delivery_app/provider/liked_provider.dart';
import 'package:food_delivery_app/provider/product_provider.dart';
import 'package:food_delivery_app/provider/test_cart_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveData.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => categoriesprovider()),
        ChangeNotifierProvider(
          create: (context) => customerprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => likeprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => productprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TestCartProvider(),
        )
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: navigationpage()),
    );
  }
}
