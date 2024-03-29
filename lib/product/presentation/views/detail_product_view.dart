import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../admin/controller/add_edit_proudct.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData; // Pass product data to the detail page

  const ProductDetailPage({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              productData['imageName'],
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 10),
            Text(
              '${productData['model']} ${productData['brand']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ${productData['price']}\$',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProduct(productActionType: ProductActionType.edit, productData: productData,)// EditProduct(productData:{},),
                        ));
                  },
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: ()async {

                    try {
                      await FirebaseFirestore.instance.collection('product').doc(productData['documentId']).delete();
                      Navigator.pop(context);
                    } on Exception {
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // Use red color for the delete button
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


