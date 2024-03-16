import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/firebase/firebase_options.dart';
import '../../product/domain/entity/car_product_entity.dart';

class AuthResult {
  bool isSuccess;
  String? error;

  AuthResult({
    required this.isSuccess,
    this.error,
  });
}

class FirebaseManager {

  // XFile? xFile;
  // Private constructor to prevent instantiation from outside.
  FirebaseManager._();

  // Singleton instance.
  static final FirebaseManager _instance = FirebaseManager._();

  // Factory method to access the singleton instance.
  factory FirebaseManager() => _instance;

  FirebaseAuth ? firebaseAuth;
  User? firebaseUser;

  Future<AuthResult> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return AuthResult(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'user-not-found') {
        errorMessage =
        'user-not-found';
      } else if (e.code == 'wrong-password') {
        // Handle the case where password is incorrect
        errorMessage =
        'wrong-password';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'invalid credentials';
      }

      return AuthResult(isSuccess: false, error: e.message);
    } catch (e) {
      // Handle other exceptions
      return AuthResult(isSuccess: false, error: e.toString());
    }
  }

  // Register method.
  Future<AuthResult> register(String email, String password,
      String role) async {
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var collect = FirebaseFirestore.instance
          .collection('users');
      await collect.add(
        {
          'id': user.user?.uid,
          'email': email,
          'role': role,
          'createdAt': DateTime
              .now()
              .millisecondsSinceEpoch
        },
      );

      return AuthResult(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'weak-password') {
        errorMessage =
        'weak-password';
      } else if (e.code == 'email-already-in-use') {
        errorMessage =
        'The account already exists for that email.';
      }
      return AuthResult(isSuccess: false, error: errorMessage);
    } catch (e) {
      // Handle other exceptions
      return AuthResult(isSuccess: false, error: e.toString());
    }
  }

  // Logout method.
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    firebaseUser = FirebaseAuth.instance.currentUser;
  }

  Future<List<Car>?> getCars() async {
        }


  Future<void> addCar(Car car) async {
    try {
      var collection = FirebaseFirestore.instance.collection('product');
      await collection.add({
        "id": car.id,
        "model": car.model,
        "brand": car.brand,
        'year': car.year,
        'color': car.color,
        'price': car.price,
        'description': car.description, // Corrected to 'description'
        'call': car.callMe, // Assuming 'call' is correct, otherwise adjust accordingly
        'imageName': car.imageName,
        'createdAt': car.createdAt,
      });
    } catch (e) {
      print('Error saving product to Firestore: $e');
      throw(e);
    }
  }

  Future<void> editCar(Car car) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('product');
    try {
      // Query for the document with the specified ID
      QuerySnapshot querySnapshot = await collectionReference.where('id', isEqualTo: car.id).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the first matching document
        var documentId = querySnapshot.docs.first.id;

        // Update the document with new data
        await collectionReference.doc(documentId).update({
          "model": car.model,
          "brand": car.brand,
          'year': car.year,
          'color': car.color,
          'price': car.price,
          'description': car.description,
          'call': car.callMe,
          'imageName': car.imageName,
          'createdAt': car.createdAt,
          // Add other fields as needed
        });

      } else {
        // Handle case where no matching document is found
        throw Exception('No document found with the specified ID.');
      }
    } catch (e) {
      // Handle errors
      print('Error updating document: $e');
      throw(e);
    }
  }


    Future<void> removeCar(String productId) async {
    }

  Future<bool> isAdmin() async {
    var role = "";
    final id = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection("users");
    final result = await collection.where("id", isEqualTo: id).get();
    if (result.docs.isNotEmpty) {
      role = result.docs.first.data()['role'];
    }
    return role == "admin";
    }
  }