import 'package:flutter/material.dart';
import 'package:food_delivery_app/custmerpage.dart';
import 'package:food_delivery_app/home.dart';
import 'package:food_delivery_app/productpage.dart';

class navigationpage extends StatefulWidget {
  const navigationpage({super.key});

  @override
  State<navigationpage> createState() => _navigationpageState();
}

class _navigationpageState extends State<navigationpage> {
  int selectedpage = 0;
  List pages = [const homepage(), productpage(), customerpage()];
  void selectitem(int index) {
    setState(() {
      selectedpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 250, 203),
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 201, 250, 203),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(59), topRight: Radius.circular(59)),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Customer',
            ),
          ],
          currentIndex: selectedpage,
          onTap: selectitem,
          selectedItemColor: Colors.white,
          backgroundColor: const Color.fromARGB(0, 199, 248, 208),
        ),
      ),
      body: pages.elementAt(selectedpage),
    );
  }
}
