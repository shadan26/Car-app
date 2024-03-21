import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/widget/drop_down_widget.dart';
import '../../../core/utils/widget/grid_view_product.dart';
import '../../../product/domain/entity/car_product_entity.dart';
import '../../../core/utils/widget/local_filter_car.dart';
import '../../../core/utils/widget/firebase_filter_car.dart';
import '../../../product/presentation/views/authentication/login_screen.dart';
import '../../../product/presentation/views/detail_product_view.dart';


class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {
  FilterDialog dialog = FilterDialog();
  Stream<QuerySnapshot> getCarsStream() {
    return FirebaseFirestore.instance.collection('product').snapshots();
  }

  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';
  String? selectedCategory;
  List<Car>? selectedCarList;


  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime
      .now()
      .millisecondsSinceEpoch);

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
                showDialog(context: context, builder: (BuildContext context) {
                  return FilterDialog();
                });

              },
              icon: const Icon(Icons.search, color: Colors.cyan),
            ),
            IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return Carfilter();
                });

              },
              icon: const Icon(Icons.refresh, color: Colors.green),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) =>
              [
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
        floatingActionButton: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 10),
          ],
        ),
        body: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseManager().getCars(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return Column(
                children: [
                  DropDownCategory(),
                  Expanded(
                    child:Gridviewproduct(snapshot: snapshot),
                    // GridView.builder(
                    //   gridDelegate:
                    //   const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 10,
                    //     mainAxisSpacing: 10,
                    //   ),
                    //   itemCount: snapshot.data!.docs.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     final data = snapshot.data!.docs[index].data()
                    //     as Map<String, dynamic>;
                    //     return InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 ProductDetailPage(productData: data),
                    //           ),
                    //         );
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(5),
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Colors.white,
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment:
                    //           CrossAxisAlignment.start,
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             Image.network(
                    //               data['imageName'],
                    //               errorBuilder:
                    //                   (context, error, stackTrace) =>
                    //               const Icon(Icons.error),
                    //               height: 100,
                    //             ),
                    //             Text(
                    //               "${data['brand']} ${data['model']}",
                    //               style: const TextStyle(
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 10),
                    //             Align(
                    //               alignment: Alignment.bottomLeft,
                    //               child: Text(
                    //                 "${data['price']}\$",
                    //                 style: const TextStyle(
                    //                   fontSize: 10,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.red,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Future<void> getData(String model, int price, String brand) async {
  //   CollectionReference productRef = FirebaseFirestore.instance.collection(
  //       "product");
  //
  //   try {
  //     // Construct the query based on selected filters
  //     QuerySnapshot querySnapshot = await productRef
  //         .where("model", isEqualTo: model.isNotEmpty
  //         ? model
  //         : null) // Apply model filter if not empty
  //         .where("price", isEqualTo: price > 0
  //         ? price
  //         : null) // Apply price filter if greater than 0
  //         .where("brand", isEqualTo: brand.isNotEmpty
  //         ? brand
  //         : null) // Apply brand filter if not empty
  //         .get();
  //
  //     // Iterate through the results and do something with the data
  //     querySnapshot.docs.forEach((DocumentSnapshot document) {
  //       print(document.data());
  //     });
  //   } catch (e) {
  //     print("Error getting documents: $e");
  //   }
  // }


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
