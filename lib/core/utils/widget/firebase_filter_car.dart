
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return AlertDialog(
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
            Text('Price:'),
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
            getData(selectedModel, selectedPrice, selectedBrand);
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Future<void> getData(String model, int price, String brand) async {
    CollectionReference productRef = FirebaseFirestore.instance.collection("product");
    try {
      QuerySnapshot querySnapshot = await productRef
          .where("model", isEqualTo: model.isNotEmpty ? model : null)
          .where("brand", isEqualTo: brand.isNotEmpty ? brand : null)
          .where("price", isGreaterThanOrEqualTo: price)
          .get();

      filteredCars.clear();
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        filteredCars.add(document.data() as Map<String, dynamic>);
      });

      // Update the UI
      setState(() {});

      Navigator.push(context, MaterialPageRoute(builder: (context) => _buildCarList()));

    } catch (e) {
      print("Error getting documents: $e");
      Navigator.pop(context);
    }
  }

  Widget _buildCarList() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebasse filter results'),
      ),
      body: Column(
        children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredCars.length,
            itemBuilder: (context, index) {
              final car = filteredCars[index];
              return ListTile(
                title: Text(car['model']),
                subtitle: Text(car['brand']),
                trailing: Text('\$${car['price'].toString()}'),
                leading: Image.network(
                  car['imageName'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}
