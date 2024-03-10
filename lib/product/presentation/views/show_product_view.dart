import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import '../../../constent.dart';
import '../../domain/entity/car_product_entity.dart';
import '../widgets/add_proudct.dart';
import 'detail_product_view.dart';
import 'edit.dart';

class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {
  String? selectedCategory;
  List<Car>? selectedCarList;
  String? role;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection("users");
    final result = await collection.where("id", isEqualTo: id).get();
    if (result.docs.isNotEmpty) {
      final roleFi = result.docs.first.data()['role'];
      setState(() {
        role = roleFi;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Replace with your desired color
          title: const Text("Homepage"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                openFilterDialog();
              },
              icon: const Icon(Icons.filter, color: Colors.cyan),
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
            if (role == 'admin')
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProduct(),
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
                FirebaseFirestore.instance.collection('product').snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return role == 'admin'
                  ? ListView.builder(
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
                                  data['imageNmae'],
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
                                          return EditProduct(productData: data);
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
                                            print('Error deleting document: $e');
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
                    )
                  : Column(children: [
                      DropdownButton<String>(
                        hint: const Text('Select a category'),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('all'),
                          ),
                          ...carInfo.map((car) {
                            return DropdownMenuItem<String>(
                              value: car["carText"],
                              child: Text(car["carText"]),
                            );
                          }).toList(),
                        ],
                      ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.network(
                                    data['imageNmae'],
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
                      ))
                    ]);
            },
          ),
        ),
      ),
    );
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Car>(
      context,
      listData: carList,
      selectedListData: selectedCarList,
      choiceChipLabel: (Car) {
        return '${Car?.model}';
      },
      validateSelectedItem: (List<Car>? selected, Car? val) {
        return selected?.contains(val) ?? false;
      },
      onItemSearch: (Car car, String query) {
        return car.model.toLowerCase().contains(query.toLowerCase()) ||
            car.brand.toLowerCase().contains(query.toLowerCase()) ||
            car.year.toString().contains(query.toLowerCase()) ||
            car.price.toString().contains(query.toLowerCase());
      },
      onApplyButtonClick: (List<Car>? selectedItems) {
        setState(() {
          selectedCarList = selectedItems;
        });
        Navigator.pop(context); // Close the dialog
      },
    );
  }

  void handleLogout(BuildContext context) {
    if (kDebugMode) {
      print('Logging out');
    }
  }
}
