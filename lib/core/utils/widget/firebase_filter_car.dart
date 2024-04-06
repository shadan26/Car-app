import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grid_view_product.dart';

class Carfilter extends StatefulWidget {
  @override
  _CarfilterState createState() => _CarfilterState();
}

class _CarfilterState extends State<Carfilter> {
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';
  List<Map<String, dynamic>> filteredCars = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('product').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }


              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AlertDialog(
                      title: Text('Firebase Filter Cars'),
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
                            const Text('Price:'),
                            Slider(
                              value: selectedPrice.toDouble(),
                              min: 0,
                              max: 50000,
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
                                '',
                                'Toyota',
                                'Honda',
                                'Ford',
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
                      actions: [
                        InkWell(
                          onTap: () async {
                            CollectionReference productRef = FirebaseFirestore.instance.collection("product");
                            try {
                              QuerySnapshot querySnapshot = await productRef
                                  .where("model", isEqualTo: selectedModel.isNotEmpty ? selectedModel : null)
                                  .where("brand", isEqualTo: selectedBrand.isNotEmpty ? selectedBrand : null)
                                  .where("price", isGreaterThanOrEqualTo: selectedPrice)
                                  .get();

                              filteredCars.clear();
                              for (var document in querySnapshot.docs) {
                                filteredCars.add(document.data() as Map<String, dynamic>);
                              }

                              Navigator.pop(context, querySnapshot);
                            } catch (e) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}





//   Future<void> getData(String model, int price, String brand, List<DocumentSnapshot> docs) async {
//     CollectionReference productRef = FirebaseFirestore.instance.collection("product");
//     try {
//       QuerySnapshot querySnapshot = await productRef
//           .where("model", isEqualTo: model.isNotEmpty ? model : null)
//           .where("brand", isEqualTo: brand.isNotEmpty ? brand : null)
//           .where("price", isGreaterThanOrEqualTo: price)
//           .get();
//
//       filteredCars.clear();
//       querySnapshot.docs.forEach((DocumentSnapshot document) {
//         filteredCars.add(document.data() as Map<String, dynamic>);
//       });
//
//       Navigator.pop(context); // Close the dialog after fetching data
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => GridViewProduct(snapshot: productRef)), // You may need to pass filteredCars instead of snapshot here
//       );
//     } catch (e) {
//       print("Error getting documents: $e");
//       Navigator.pop(context);
//     }
//   }
// }
//
//
// Widget _buildCarList() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebasse filter results'),
//       ),
//       body: Column(
//         children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredCars.length,
//             itemBuilder: (context, index) {
//               final car = filteredCars[index];
//               return ListTile(
//                 title: Text(car['model']),
//                 subtitle: Text(car['brand']),
//                 trailing: Text('\$${car['price'].toString()}'),
//                 leading: Image.network(
//                   car['imageName'],
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             },
//           ),
//         ),
//         ],
//       ),
//     );
//   }

