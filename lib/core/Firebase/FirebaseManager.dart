import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/firebase/firebase_options.dart';
import '../../product/domain/entity/car_product_entity.dart';
import '../../product/domain/entity/notficiation_data.dart';
import '../../product/domain/entity/user_data.dart';

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

  DateTime now = DateTime.now();
  static final FirebaseManager _instance = FirebaseManager._();
  FirebaseMessaging?firebaseMessaging;

  factory FirebaseManager() => _instance;

  FirebaseAuth? firebaseAuth;
  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(
      DateTime
          .now()
          .millisecondsSinceEpoch);

  Map<String, dynamic>? notificationData;


  Future<AuthResult> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return AuthResult(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {} else
      if (e.code == 'wrong-password') {} else
      if (e.code == 'invalid-credential') {}

      return AuthResult(isSuccess: false, error: e.message);
    }
    catch (e) {
      return AuthResult(isSuccess: false, error: e.toString());
    }
  }

  Future<String?> getToken() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    String? token = await FirebaseMessaging.instance.getToken();

    if (kDebugMode) {
      print("Token = $token");
    }
    return token;
  }

  Future<AuthResult> register(String email, String password,
      String role) async {
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var collect = FirebaseFirestore.instance.collection('users');
      await collect.add(
        {
          'id': user.user?.uid,
          "token": await getToken(),
          'email': email,
          'role': role,
          'createdAt': DateTime
              .now()
              .millisecondsSinceEpoch
        },
      );

      await FirebaseMessaging.instance.subscribeToTopic(role);

      return AuthResult(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {} else
      if (e.code == 'email-already-in-use') {}
      return AuthResult(isSuccess: false, error: e.message);

    } catch (e) {
      return AuthResult(isSuccess: false, error: e.toString());
    }
  }

  // Future<void> note() async {
  //   var userDocRef = FirebaseFirestore.instance.collection('users').doc('role');
  //   await userDocRef.update({
  //     'notification': FieldValue.arrayUnion([
  //       {
  //         'time': now,
  //         'title': 'Notification Title',
  //         'body': 'Notification Body',
  //       }
  //     ])
  //   });
  // }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('islogin');
  }

  Stream<QuerySnapshot> getCars() {
    return FirebaseFirestore.instance
        .collection("product")
        .orderBy('createdAt', descending: true)
        .startAt([currentTimestamp]).snapshots();
  }

  Future<UserData> getUserData() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var ref = FirebaseFirestore.instance
        .collection("users");
    QuerySnapshot querySnapshot =
    await ref.where("id", isEqualTo: userId).get();
    var userDoc = querySnapshot.docs.first;
    return UserData(id: userDoc["id"],
        email: userDoc["email"],
        createdAt: userDoc["createdAt"],
        role: userDoc["role"],
        token: userDoc["token"]);
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
      if (kDebugMode) {
        print('Error saving product to Firestore: $e');
      }
      rethrow;
    }
  }

  Future<void> editCar(Car car) async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('product');
    try {
      QuerySnapshot querySnapshot = await collectionReference.where('id', isEqualTo: car.id)
          .get();

      if (kDebugMode) {
        print('Query returned ${querySnapshot.size} documents');
      } // Debugging statement

      if (querySnapshot.docs.isNotEmpty) {
        var documentId = querySnapshot.docs.first.id;
        if (kDebugMode) {
          print("car.imageName = ${car.imageName}");
        }
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
        });
      } else {
        if (kDebugMode) {
          print('No document found with the specified ID.');
        } // Debugging statement
        // throw Exception('No document found with the specified ID.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
      }
      rethrow;
    }
  }

  Future<void> removeCar(String id) async {
    final collectionReference =
    FirebaseFirestore.instance.collection('product');
    try {
      final result =
      await collectionReference.where('id', isEqualTo: id).get();

      if (result.docs.isNotEmpty) {
        final documentId = result.docs.first.id;
        await collectionReference.doc(documentId).delete();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error deleting document: $e');
      }
      if (kDebugMode) {
        print(stackTrace);
      }
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

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("islogin") ?? false;
  }

  Future<bool> truelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("islogin", true);
  }

  Future<void> sendPushNotificationTopic(String topicName) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'key=AAAAIIrgDYY:APA91bGiohiclMOAwTOScZJSlQ6qKYsP4yV9UQWqANqs-MdpBqPxdJgO5jWwcY3h3t_eG4TDEGCZrfai9HZkewBqJHqklVbsY6M15qWOU8dHTlYa-gnmtjakXeF2wE5Q94VCHRoyC6Dp',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "Truecar",
              'title': 'i want to bay a car ',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            // 'to':
            //     "fSPrMcRAS2-Hj-2VBzmd8q:APA91bETj-WS753lpy3r1w4KfBN6ZZe74EM_TETGLxQPznvntCTd5P9fr4NezBghmV0_Q_u8rbLOu7mR1BOPQnPqPrJXTvy-Wmx4QcdUe3IO3bLfL6IXv5Sdq3onohsX8X4qxxEWciuE",
            'to': '/topics/$topicName',
            //'token': authorizedSupplierTokenId
          },
        ),
      );
      if (kDebugMode) {
        print("response = ${response.body}");
      }
      if (kDebugMode) {
        print("response = ${response.statusCode}");
      }
    } catch (e) {
      e;
    }
  }


  void handleNotification(String title, String body, String email,
      String time) {
    // Implement your notification handling logic here
  }


  void sendNotification({String? title, String? body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Set the settings for various platforms
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );


    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {

      },
    );
  }

  Future<void> addNotification(NotificationData notification) async {
    try {
      var collection = FirebaseFirestore.instance.collection('notifications');
      await collection.add({
        "id": collection.doc().id,
        "title": notification.title,
        "body": notification.body,
        "userEmail": notification.userEmail,
        'userId': notification.userId,
        'createdAt': notification.createdAt,
        'imageURL': notification.imageURL,
        'isOpened': notification.isOpened,
        'isViewed': notification.isViewed
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving product to Firestore: $e');
      }
      rethrow;
    }
  }

  Stream<QuerySnapshot> getNotificationsForAdmin() {
    return FirebaseFirestore.instance
        .collection("notifications")
        .orderBy('createdAt', descending: true)
        .startAt([currentTimestamp]).snapshots();
  }

  Future<int> getUnViewedNotificationCountForAdmin() async {
    var ref = FirebaseFirestore.instance
        .collection("notifications");
    QuerySnapshot querySnapshot =
    await ref.where("isViewed", isEqualTo: false).get();
    var numberOfUnOpenedNotifications = querySnapshot.docs.length;
    return numberOfUnOpenedNotifications;
  }

  Future<void> readNotification(String id) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("id", isEqualTo: id)
        .get();
    await querySnapshot.docs.first.reference.update({'isOpened' : true});
  }

  Future<void> viewNotifications() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .get();
    for (var element in querySnapshot.docs) {
      element.reference.update({'isViewed': true});
    }
  }
}
