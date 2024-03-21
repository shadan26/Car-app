import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../product/domain/entity/car_product_entity.dart';
import '../../controller/add_edit_proudct.dart';
import '../../../product/presentation/views/detail_product_view.dart';
import '../../../core/Firebase/FirebaseManager.dart';

class Listofadmin extends StatefulWidget {
  const Listofadmin({super.key});

  @override
  State<Listofadmin> createState() => _ListofadminState();
}

class _ListofadminState extends State<Listofadmin> {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseManager().getCars(),
    builder: (BuildContext context, snapshot) {
    if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
    return const CircularProgressIndicator();
    }
    return  ListView.builder(
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
                        await FirebaseManager().removeCar(Car(id: data['id']));

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
  });
}}
