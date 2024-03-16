
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'grid_view_filter.dart';

class Filtercar extends StatefulWidget {
  const Filtercar({Key? key}) : super(key: key);

  @override
  _YourClassState createState() => _YourClassState();
}

class _YourClassState extends State<Filtercar> {
  final CollectionReference productsRef =
  FirebaseFirestore.instance.collection("products");
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> getData() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection("product");
    final result = await collection.where('model', isEqualTo: selectedModel).get() ;
    if (result.docs.isNotEmpty) {
      final roleFi = result.docs.first.data()['role'];
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _applyFilters ,
      child: Text('Open Filter Dialog'),
    );
  }


  void _applyFilters() {
    Query<Map<String, dynamic>> query = productsRef as Query<Map<String, dynamic>>;
    if (selectedModel.isNotEmpty) {
      query = query.where('model', isEqualTo: selectedModel);
    }
    if (selectedBrand.isNotEmpty) {
      query = query.where('brand', isEqualTo: selectedBrand);
    }
    if (selectedPrice > 0) {
      query = query.where('price', isLessThanOrEqualTo: selectedPrice);
    }

    query.get().then((querySnapshot) {
      List<Map<String, dynamic>> filteredData = [];
      for (var doc in querySnapshot.docs) {
        filteredData.add(doc.data());
      }


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GridViewScreen(filteredData: filteredData),
        ),
      );
    });

    // Close the dialog
    Navigator.pop(context);
  }
}

