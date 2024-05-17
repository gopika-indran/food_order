import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigtion.dart';
import 'package:food_delivery_app/cartpage.dart';
import 'package:food_delivery_app/customerapi.dart';
import 'package:food_delivery_app/customs/text_cust.dart';
import 'package:food_delivery_app/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class customerpage extends StatelessWidget {
  customerpage({Key? key}) : super(key: key);
  TextStyle textStyle = const TextStyle(
      color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 250, 203),
      drawer: const EndDrawerButton(),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 201, 250, 203),
          title: const Text(
            "Customers",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const navigationpage(),
                      ));
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ))
          ],
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: Consumer<customerprovider>(
        builder: (BuildContext context, customerprovider value, Widget? child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: value.searchcontroller,
                  onChanged: value.searchfield,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.grey.shade400,
                      ),
                      hintText: "Search",
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      suffixIcon: Container(
                        height: 30,
                        width: 70,
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.qr_code,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const CircleAvatar(
                              radius: 16,
                              child: Icon(Icons.add_sharp),
                            )
                          ],
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
              ),
              FutureBuilder(
                  future: fetchcustomer(value.value),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data["data"].length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data["data"][index];

                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.94,
                                child: Padding(
                                  padding: const EdgeInsets.all(11),
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<customerprovider>(context,
                                              listen: false)
                                          .setCustomerId(data["id"].toString());
                                      print(data["id"]);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const cartpage(),
                                          ));
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 10,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "https://www.pngkey.com/png/full/202-2024792_profile-icon-png.png"))),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.64,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 2, 0, 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(data["name"],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      23)),
                                                      SizedBox(
                                                        child: Row(
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 11,
                                                              child: Icon(Icons
                                                                  .call_sharp),
                                                            ),
                                                            Icon(
                                                              Icons.chat,
                                                              size: 23,
                                                              color: Colors
                                                                  .lightGreen
                                                                  .shade500,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 2, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Text('ID : ',
                                                          style: textStyle),
                                                      Text(
                                                        data["id"].toString(),
                                                        style: textStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          data["street"],
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          ",",
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          data["city"],
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          ",",
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          data["state"],
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          ",",
                                                          style: textStyle,
                                                        ),
                                                        Text(
                                                          data["country"],
                                                          style: textStyle,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Text("No data to display");
                    }
                  })
            ],
          );
        },
      ),
    );
  }
}
