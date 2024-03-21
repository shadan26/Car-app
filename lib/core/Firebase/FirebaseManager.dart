
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  FirebaseManager._();

  // Singleton instance.
  static final FirebaseManager _instance = FirebaseManager._();

  // Factory method to access the singleton instance.
  factory FirebaseManager() => _instance;

  FirebaseAuth ? firebaseAuth;
  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime
      .now()
      .millisecondsSinceEpoch);

  Future<AuthResult> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return AuthResult(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {} else
      if (e.code == 'wrong-password') {} else
      if (e.code == 'invalid-credential') {}

      return AuthResult(isSuccess: false, error: e.message);
    }
    // catch (e) {
    //   return AuthResult(isSuccess: false, error: e.toString());
    // }
  }

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
      if (e.code == 'weak-password') {} else
      if (e.code == 'email-already-in-use') {}
      return AuthResult(isSuccess: true, error: e.message);
    }
    catch (e) {
      // Handle other exceptions
      return AuthResult(isSuccess: true, error: e.toString());
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('islogin');
    //  await FirebaseAuth.instance.signOut();
    // firebaseUser = FirebaseAuth.instance.currentUser;
  }


  Stream<QuerySnapshot> getCars() {
    return FirebaseFirestore.instance.collection("product").orderBy(
        'createdAt', descending: true).
    startAt([currentTimestamp]).
    snapshots();
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
        'description': car.description,
        'call': car.callMe,
        'imageName': car.imageName,
        'createdAt': car.createdAt,
      });
    } catch (e) {
      print('Error saving product to Firestore: $e');
      throw(e);
    }
  }

  Future<void> editCar(Car car) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('product');
    try {
      // Query for the document with the specified ID
      QuerySnapshot querySnapshot = await collectionReference.where(
          'id', isEqualTo: car.id).get();

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
        throw Exception('No document found with the specified ID.');
      }
    } catch (e) {
      print('Error updating document: $e');
      throw(e);
    }
  }


  Future<void> removeCar(Car car) async {
    final collectionReference = FirebaseFirestore.instance.collection('product');

    try {
      final result = await collectionReference
          .where('id', isEqualTo: car.id)
          .get();

      if (result.docs.isNotEmpty) {
        final documentId = result.docs.first.id;
        await collectionReference.doc(documentId).delete();
      }
    } catch (e, stackTrace) {
      print('Error deleting document: $e');
      print(stackTrace);
    }
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

  Future<bool> isloggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("islogin") ?? false;
  }

  Future<bool> truelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("islogin", true);
  }
}


