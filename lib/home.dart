import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/cartpage.dart';
import 'package:food_delivery_app/categoryclass.dart';
import 'package:food_delivery_app/customs/text_cust.dart';
import 'package:food_delivery_app/discovery_clss.dart';
import 'package:food_delivery_app/provider/categoriespro.dart';
import 'package:food_delivery_app/provider/liked_provider.dart';
import 'package:provider/provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final List<String> offerimages = [
    "https://www.bdtask.com/blog/assets/plugins/ckfinder/core/connector/php/uploads/images/promote-your-food-combo-offers.jpg",
    "https://w7.pngwing.com/pngs/39/515/png-transparent-summer-sale-special-offer-banner-fruits-floral.png",
    "https://couponswala.com/blog/wp-content/uploads/2022/09/Food-Combo-Offers.jpg",
    "https://img.freepik.com/premium-psd/special-healthy-food-menu-restaurant-promotion-social-media-post-feed-banner-template_485905-289.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTynb95H32sNpzUgYCvM7z8HkNHrFhL_v6zKw&usqp=CAU"
  ];

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final favprovider = Provider.of<likeprovider>(context, listen: false);
    final categoriesproviders = Provider.of<categoriesprovider>(context);
    final List listcategories = [
      categclass(imgurl: "assets/fruit.png", name: "Fruits"),
      categclass(imgurl: "assets/veg.png", name: "vegtables"),
      categclass(imgurl: "assets/spice.png", name: "spice"),
      categclass(imgurl: "assets/bread.png", name: "bread"),
    ];
    List filteredCategories = listcategories.where((category) {
      return category.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    final List<Discoveryitems> discoveryitems = [
      Discoveryitems(imageUrl: "assets/crab.png", name: "Crab", rate: "100"),
      Discoveryitems(imageUrl: "assets/duck.png", name: "Duck", rate: "200"),
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 250, 203),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textcust(
                  title: "Good day!👋",
                  bold: FontWeight.bold,
                  colortitle: const Color.fromARGB(255, 1, 47, 2),
                  size: 30,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Badge(
                    label: textcust(title: "0"),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const cartpage(),
                            ));
                      },
                      icon: const Icon(Icons.shopping_cart),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 28, left: 28),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search grocery",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CarouselSlider(
                items: offerimages.map((imageurl) {
                  return Builder(
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          imageurl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height / 5,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 30),
            child: textcust(
              title: "Categories",
              bold: FontWeight.bold,
              size: 20,
              colortitle: const Color.fromARGB(255, 1, 47, 2),
            ),
          ),
          Flexible(
            flex: 8,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listcategories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      categoriesproviders.selectedindex = index;
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26)),
                        height: MediaQuery.of(context).size.height / 7,
                        width: 90,
                        child: Column(
                          children: [
                            Image.asset(listcategories[index].imgurl),
                            Text(listcategories[index].name)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textcust(
                  title: "Discovery",
                  size: 20,
                  colortitle: const Color.fromARGB(255, 1, 47, 2),
                  bold: FontWeight.bold,
                ),
                textcust(
                  title: "See all >",
                  colortitle: const Color.fromARGB(255, 29, 85, 31),
                  size: 15,
                )
              ],
            ),
          ),
          Flexible(
              flex: 4,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: discoveryitems.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      const SizedBox(
                        height: 90,
                        width: 230,
                      ),
                      Container(
                        height: 60,
                        width: 130,
                        decoration: const BoxDecoration(),
                      ),
                      Positioned(
                        top: 30,
                        left: 20,
                        child: Container(
                          height: 120,
                          width: 230,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        left: 30,
                        child: Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      discoveryitems[index].imageUrl))),
                        ),
                      ),
                      Positioned(
                        top: 28,
                        right: 5,
                        child: IconButton(onPressed: () {
                          favprovider.favicon(index: index);
                        }, icon: Consumer<likeprovider>(
                          builder:
                              (context, likeprovider value, Widget? child) {
                            return Icon(
                              value.likedproduct[index]
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline,
                              color: Colors.red,
                            );
                          },
                        )),
                      ),
                      Positioned(
                          top: 90,
                          left: 40,
                          child: Column(
                            children: [
                              textcust(
                                title: discoveryitems[index].name,
                                bold: FontWeight.bold,
                                size: 20,
                                colortitle:
                                    const Color.fromARGB(255, 29, 85, 31),
                              ),
                              Row(
                                children: [
                                  textcust(
                                    title: "\$${discoveryitems[index].rate}",
                                    size: 26,
                                    bold: FontWeight.bold,
                                    colortitle:
                                        const Color.fromARGB(255, 29, 85, 31),
                                  ),
                                  textcust(
                                    title: "/kg",
                                    colortitle: Colors.grey,
                                  )
                                ],
                              ),
                            ],
                          )),
                    ],
                  );
                },
              ))
        ],
      )),
    );
  }
}
