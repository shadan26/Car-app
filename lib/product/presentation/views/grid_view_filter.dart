import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Product Views/user_home_page.dart';

class GridViewScreen extends StatelessWidget {
  final List<dynamic> filteredData;

  const GridViewScreen({Key? key, required this.filteredData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (streamSnapshot.hasError) {
          return Center(child: Text('Error: ${streamSnapshot.error}'));
        } else if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  final String id = documentSnapshot.id;
                  final String url = documentSnapshot['imgUrl'];
                  final String status = documentSnapshot['status'];
                  final String brand = documentSnapshot['brand'];
                  final String name = documentSnapshot['name'];
                  final double price = documentSnapshot['price'];

                  if (status == "close") {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowProductView()));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          constraints: const BoxConstraints.expand(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(url),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.3, vertical: 0.4),
                                child: Text(
                                  '$brand $name',
                                  style: TextStyle(color: Colors.cyanAccent),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                                child: Text(
                                  'RM ${price.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(); // Return an empty SizedBox if not approved
                },
              ),
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
