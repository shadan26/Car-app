import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/Firebase/FirebaseManager.dart';
import '../../../core/utils/widget/firebase_filter_car.dart';
import '../../Admin Notifications/Controller/admin_notifications.dart';
import '../widget/list_of_admin.dart';
import '../../../core/utils/widget/local_filter_car.dart';
import '../../../product/domain/entity/car_product_entity.dart';
import '../../../product/presentation/views/authentication/login_screen.dart';
import '../../controller/add_edit_proudct.dart';

class ShowAdminProductView extends StatefulWidget {
  final List<QueryDocumentSnapshot<Object?>>? docs;
  const ShowAdminProductView({Key? key,this.docs}) : super(key: key);

  @override
  State<ShowAdminProductView> createState() => _ShowAdminProductViewState();
}

class _ShowAdminProductViewState extends State<ShowAdminProductView> {
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';
  String? selectedCategory;
  List<Car>? selectedCarList;
  User? firebaseUser;
  Map<String, dynamic>? notificationData;
  var currentTimestamp =
  Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
  int notificationCount = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late final Map<String, dynamic>? productData;
 List<QueryDocumentSnapshot<Object?>> ?docs;

  @override
  void initState() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${message.notification!.title}"),
          ),
        );
      }
    });

    FirebaseManager().getUnViewedNotificationCountForAdmin().then((value) => {
      setState(() {
        notificationCount = value;
      })
    });

    super.initState();
  }

  Listofadmin admin = Listofadmin();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Homepage"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FilterDialog();
                  },
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AdminNotifications();
                  },
                )).then((value) {
                  FirebaseManager()
                      .getUnViewedNotificationCountForAdmin()
                      .then((value) => {
                    setState(() {
                      notificationCount = value;
                    })
                  });
                });
              },
              icon: Stack(
                children: [
                  const Icon(Icons.notification_add, color: Colors.white),
                  if (notificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 1,
                          minHeight: 1,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Carfilter();
                  },
                ).then((value) {
                  if (value != null) {
                    print(value);
                    var s = value as QuerySnapshot;
                    docs = s.docs;
                    setState(() {
                      // Update the UI with the new data
                    });
                  }
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.green),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      handleLogout(context);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditProduct(
                      productActionType: ProductActionType.add,
                    ),
                  ),
                ).then((value) {
              if (value != null) {
                 setState(() {
              var addedCar = value as Car;
          docs?.add(addedCar.model as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.callMe as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.brand as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.year as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.imageName as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.id as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.description as QueryDocumentSnapshot<Object?>);
          docs?.add(addedCar.color as QueryDocumentSnapshot<Object?>);

             });
              }});
                },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
          ],
        ),
        body: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:  FirebaseFirestore.instance
                .collection("product")
                .orderBy('createdAt', descending: true)
                .startAt([currentTimestamp]).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (docs?.isEmpty != null) {
                admin.docs = this.docs;
              } else {
                admin.docs = snapshot.data?.docs;
                print("###################");
                print(admin.docs);
              }

                print("###################");
                print(admin.docs);
                print("############");

              return admin;
            },
          ),
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    await FirebaseManager().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    if (kDebugMode) {
      print('Logging out');
    }
  }
}
