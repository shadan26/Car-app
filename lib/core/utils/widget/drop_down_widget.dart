
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Firebase/FirebaseManager.dart';
import 'grid_view_product.dart';

class DropDownCategory extends StatefulWidget {
  const DropDownCategory({Key? key}) : super(key: key);

  @override
  State<DropDownCategory> createState() => _DropDownCategoryState();
}

class _DropDownCategoryState extends State<DropDownCategory> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseManager().getCars(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          final cars = snapshot.data?.docs.reversed.toList();
          List<DropdownMenuItem<String>> categories = [
            const DropdownMenuItem(
              value: "0",
              child: Text("All"),
            ),
          ];
          for (var product in cars!) {
            categories.add(
              DropdownMenuItem(
                value: product.id,
                child: Text(product['brand']),
              ),
            );
          }
          return DropdownButton<String>(
            hint: const Text('Select a category'),
            value: selectedCategory,
            items: categories,
            onChanged: (selectedValue) {

              setState(() {
                selectedCategory = selectedValue;
              });
              if (selectedValue != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  GridViewProduct(snapshot: snapshot,selectedCategory: selectedCategory!),

                  ),

                );
              }
            },
          );
        }
      },
    );
  }
}

class GridViewProduct extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final String? selectedCategory;

  const GridViewProduct({Key? key, required this.snapshot, this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot>? products;
    if (selectedCategory == "0") {
      products = snapshot?.data?.docs;
    } else {
      products = snapshot?.data?.docs.where((product) => product.id == selectedCategory).toList();
    }

    return
      Scaffold(
        appBar:AppBar(
          title: Text("hhh"),
        ),
        body:
              GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final data = products?[index].data() as Map<String, dynamic>;
                        return InkWell(
              onTap: () {

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
                      data['imageName'],
                      errorBuilder: (context, error, stackTrace) =>
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
      );
  }
}



