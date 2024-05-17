import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigtion.dart';
import 'package:food_delivery_app/customs/text_cust.dart';
import 'package:food_delivery_app/home.dart';
import 'package:food_delivery_app/models/cart_model.dart';
import 'package:food_delivery_app/provider/post_ordernow_provider.dart';
import 'package:food_delivery_app/provider/test_cart_provider.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartpage extends StatelessWidget {
  const cartpage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TestCartProvider>(context, listen: false).getSubTotal();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 250, 203),
      body: Consumer<TestCartProvider>(
        builder: (BuildContext context, TestCartProvider value, Widget? child) {
          return SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const navigationpage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Center(
                      child: textcust(
                        title: "My Cart",
                        bold: FontWeight.bold,
                        size: 29,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<CartItem>>(
                    future: value.getCartItems(),
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
                        final cartItems = snapshot.data!;
                        return ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 7,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      item.image,
                                      width: 80,
                                      height: 250,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          textcust(
                                            title: item.name,
                                            colortitle: const Color.fromARGB(
                                                255, 41, 113, 43),
                                            bold: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              textcust(
                                                title:
                                                    "\$ ${item.price.toString()}",
                                                colortitle:
                                                    const Color.fromARGB(
                                                        255, 41, 113, 43),
                                                bold: FontWeight.bold,
                                                size: 18,
                                              ),
                                              textcust(
                                                title: "/kg",
                                                colortitle: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    CircleAvatar(
                                      radius: 17,
                                      backgroundColor: const Color.fromARGB(
                                          255, 221, 216, 216),
                                      child: IconButton(
                                        onPressed: () {
                                          value.decrementQuantity(item);
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    textcust(title: item.quantity.toString()),
                                    const SizedBox(width: 5),
                                    CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.green,
                                      child: IconButton(
                                        onPressed: () {
                                          value.incrementQuantity(item);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    textcust(
                                      title:
                                          "\$${value.eachtotoalrate(item).toString()}",
                                      size: 22,
                                      colortitle: const Color.fromARGB(
                                          255, 41, 113, 43),
                                      bold: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textcust(title: "Subtotal"),
                              textcust(
                                title:
                                    "\$${value.totalRate.toStringAsFixed(2)}",
                                bold: FontWeight.bold,
                              ),
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
                                onPressed: () async {
                                  final cartItems = await value.getCartItems();
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  String? customerId = sharedPreferences
                                      .getString("customer_id");

                                  print('Customer ID: $customerId');
                                  print('Cart Items: ${cartItems.length}');

                                  if (customerId != null &&
                                      cartItems.isNotEmpty) {
                                    List<Map<String, dynamic>> products =
                                        cartItems.map((item) {
                                      return {
                                        "product_id": item.id,
                                        "quantity": item.quantity,
                                        "price": item.price,
                                      };
                                    }).toList();
                                    await ordersenting(
                                      id: customerId,
                                      totalPrice: value.totalRate.toInt(),
                                      products: products,
                                    );
                                    value.removingitem(context);
                                  } else {
                                    print(
                                        "Customer ID or Cart Items are not available");
                                  }
                                },
                                child: textcust(
                                  title: "CHECKOUT NOW",
                                  bold: FontWeight.bold,
                                  colortitle: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
