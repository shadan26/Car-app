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

class ShowAdminProductView extends StatefulWidget {
  const ShowAdminProductView({Key? key}) : super(key: key);

  @override
  State<ShowAdminProductView> createState() => _ShowAdminProductViewState();
}

class _ShowAdminProductViewState extends State<ShowAdminProductView> {
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';
  String? selectedCategory;
  List<Car>? selectedCarList;
  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

  var Scaffoldkey = GlobalKey<ScaffoldState>();

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
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEditProduct(productActionType: ProductActionType.add,),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
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

              return ListView.builder(
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
                      height: 120,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(
                            data['imageName'],
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${data['model']} ${data['brand']}",
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            if (kDebugMode) {
                                              print(data);
                                            }
                                            return AddEditProduct(productActionType: ProductActionType.edit, productData: data); //EditProduct(productData: data);
                                          }));
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final collectionReference =
                                  FirebaseFirestore.instance
                                      .collection('product');

                                  try {
                                    final querySnapshot =
                                    await collectionReference
                                        .where('id',
                                        isEqualTo: data['id'])
                                        .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      final documentId =
                                          querySnapshot.docs.first.id;
                                      await collectionReference
                                          .doc(documentId)
                                          .delete();
                                      if (kDebugMode) {
                                        print(
                                            'Document deleted successfully.');
                                      }
                                    } else {
                                      if (kDebugMode) {
                                        print(
                                            'No document found with name equal to "11".');
                                      }
                                    }
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print(
                                          'Error deleting document: $e');
                                    }
                                  }
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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




