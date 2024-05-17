import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigtion.dart';
import 'package:food_delivery_app/cartpage.dart';
import 'package:food_delivery_app/custmerpage.dart';
import 'package:food_delivery_app/customs/text_cust.dart';
import 'package:food_delivery_app/models/cart_model.dart';
import 'package:food_delivery_app/models/product_model.dart';
import 'package:food_delivery_app/provider/product_provider.dart';
import 'package:food_delivery_app/provider/test_cart_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

class productpage extends StatelessWidget {
  productpage({super.key});

  final List<CartItem> _cartItems = [];

  Future<List<productmodel>> productfetching() async {
    final Response =
        await http.get(Uri.parse("http://143.198.61.94:8000/api/products/"));
    if (Response.statusCode == 200) {
      final jsondata = jsonDecode(Response.body);
      List<productmodel> products = [];
      for (var item in jsondata["data"]) {
        String imageUrl = "http://143.198.61.94:8000${item["image"]}";
        products.add(productmodel(
            id: item["id"],
            name: item["name"],
            image: imageUrl,
            price: item["price"]));
      }
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Box<CartItem>> openCartBox() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    return await Hive.openBox<CartItem>('cart');
  }

  Future<List<CartItem>> getCartItems() async {
    final cartBox = await openCartBox();
    return cartBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 250, 203),
      body: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const navigationpage(),
                        ));
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 26,
                  )),
              textcust(
                title: "Products",
                size: 30,
                bold: FontWeight.bold,
                colortitle: const Color.fromARGB(255, 1, 47, 2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Badge(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const cartpage(),
                              ));
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        )),
                  ),
                ),
              )
            ],
          ),
          FutureBuilder<List<productmodel>>(
            future: productfetching(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 9,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: ClipRRect(
                                  child: Image.network(product.image),
                                )),
                                textcust(
                                  title: product.name,
                                  bold: FontWeight.bold,
                                  size: 15,
                                  colortitle:
                                      const Color.fromARGB(255, 31, 98, 34),
                                ),
                                Row(
                                  children: [
                                    textcust(
                                      title: "\$ ${product.price.toString()}",
                                      colortitle:
                                          const Color.fromARGB(255, 27, 82, 29),
                                      bold: FontWeight.bold,
                                      size: 20,
                                    ),
                                    textcust(
                                      title: "/kg",
                                      colortitle: Colors.grey,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 19,
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            final producrprov =
                                                Provider.of<productprovider>(
                                                    context,
                                                    listen: false);
                                            producrprov.addToCart(product);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${product.name} added to cart',
                                                ),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.add)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Consumer<TestCartProvider>(
              builder: (context, TestCartProvider value, child) {
            return CustomCheckOut(
              valueTotal: '${value.totalRate}',
              onPress: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => customerpage()));
              },
            );
          })
        ],
      )),
    );
  }
}

class CustomCheckOut extends StatelessWidget {
  const CustomCheckOut({
    super.key,
    required this.valueTotal,
    required this.onPress,
  });
  final String valueTotal;
  final void Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textcust(
                  title: "Subtotal",
                  size: 15,
                ),
                textcust(
                  title: "\$ $valueTotal",
                  bold: FontWeight.bold,
                  size: 19,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.green.withOpacity(0.9),
              ),
              child: Center(
                  child: TextButton(
                      onPressed: onPress,
                      child: textcust(
                        title: "CHECKOUT NOW",
                        bold: FontWeight.bold,
                        colortitle: Colors.white,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
