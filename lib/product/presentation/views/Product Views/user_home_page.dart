import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import '../../../../constent.dart';
import '../../../domain/entity/car_product_entity.dart';
import '../../widgets/add_edit_proudct.dart';
import '../../widgets/Authentication/login_screen.dart';
import '../car_filter_screen.dart';
import '../detail_product_view.dart';
import '../../widgets/edit.dart';
import '../filter_car.dart';
import '../grid_view_filter.dart';
import '../grid_view_product.dart';

class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';
  String? selectedCategory;
  List<Car>? selectedCarList;
  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

  var Scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Homepage"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //return Filtercar();
                      return AlertDialog(
                        title: Text('Filter Cars'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Model:'),
                              DropdownButton<String>(
                                value: selectedModel,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedModel = newValue!;
                                  });
                                },
                                items: <String>[
                                  '',
                                  'Camry',
                                  'Corolla',
                                  'Prius',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              Text('Price:'),
                              Slider(
                                value: selectedPrice.toDouble(),
                                min: 0,
                                max: 10000,
                                divisions: 15000,
                                onChanged: (double value) {
                                  setState(() {
                                    selectedPrice = value.toInt();
                                  });
                                },
                              ),
                              Text('Brand:'),
                              DropdownButton<String>(
                                value: selectedBrand,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedBrand = newValue!;
                                  });
                                },
                                items: <String>[
                                  '', // Empty option for no filter
                                  'Toyota',
                                  'Honda',
                                  'Ford',
                                  // Add other brands here
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context )=>const Filtercar() ));
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    });

                //Alert(context);
              },
              icon: const Icon(Icons.search, color: Colors.cyan),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () {

                      handleLogout(context);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
          ],
        ),
        body: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('product')
                    .orderBy('createdAt', descending: true).startAt([currentTimestamp])
                    .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("product")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<DropdownMenuItem<String>> Car = [];

                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              final cars =
                                  snapshot.data?.docs.reversed.toList();
                              Car.add(
                                const DropdownMenuItem(value: "0",child: Text("all")),
                              );
                              for (var product in cars!) {
                                Car.add(
                                  DropdownMenuItem(
                                    value: product.id,
                                    child: Text(product['brand']),
                                  ),
                                );
                              }
                              return DropdownButton<String>(
                                hint: const Text('Select a category'),
                                value: selectedCategory,
                                items: Car,
                                onChanged: (selectedValue) {
                                  setState(() {
                                    selectedCategory =
                                        selectedValue; // Update selectedCategory when an item is selected
                                  });
                                  print(selectedValue);
                                },
                              );
                            }
                          },
                        ),

                        // DropdownButton<String>(
                        //     hint: const Text('Select a category'),
                        //     value: selectedCategory,
                        //     onChanged: (newValue) {
                        //       setState(() {
                        //         selectedCategory = newValue;
                        //       });
                        //     },
                        //     items: [
                        //       const DropdownMenuItem<String>(
                        //         value: '',
                        //         child: Text('all'),
                        //       ),
                        //       ...carInfo.map((car) {
                        //         return DropdownMenuItem<String>(
                        //           value: car["carText"],
                        //           child: Text(car["carText"]),
                        //         );
                        //       }).toList(),
                        //     ],
                        //   ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailPage(productData: data),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.network(
                                        data['imageName'],
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                        height: 100,
                                      ),
                                      Text(
                                        "${data['brand']} ${data['model']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "${data['price']}\$",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),


      ),
    );
  }



  void handleLogout(BuildContext context) async {
    await FirebaseManager().logout();
    runApp(
        new MaterialApp(
          home: new LoginScreen(),
        )

    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    if (kDebugMode) {
      print('Logging out');
    }
  }
}




