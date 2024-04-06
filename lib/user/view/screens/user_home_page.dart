import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/widget/drop_down_widget.dart';
import '../../../core/utils/widget/grid_view_product.dart';
import '../../../core/utils/widget/local_filter_car.dart';
import '../../../core/utils/widget/firebase_filter_car.dart';
import '../../../product/presentation/views/authentication/login_screen.dart';


class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {
  FilterDialog dialog = FilterDialog();
  Stream<QuerySnapshot> getCarsStream() {
    return FirebaseFirestore.instance.collection('product').snapshots();
  }

  User? firebaseUser;
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime
      .now()
      .millisecondsSinceEpoch);

  var Scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  late Gridviewproductt girdView = Gridviewproductt();
  List<QueryDocumentSnapshot<Object?>>? docs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Homepage"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return FilterDialog();
                });

              },
              icon: const Icon(Icons.search, color: Colors.cyan),
            ),
            IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return Carfilter();
                }).then((value) {
                  var querySnapshot = value as QuerySnapshot;
                  docs = querySnapshot.docs;
                  setState(() {});
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.green),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) =>
              [
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
        floatingActionButton: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 10),
          ],
        ),
        body: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseManager().getCars(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (docs?.isEmpty != null) {
                girdView.docs = docs;
              } else {
                girdView.docs = snapshot.data?.docs;
              }
              return Column(
                children: [
                  const DropDownCategory(),
                  Expanded(
                    child: girdView,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }



  void handleLogout(BuildContext context) async {
    await FirebaseManager().logout();
    runApp(
        const MaterialApp(
          home: LoginScreen(),
        )

    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    if (kDebugMode) {
      print('Logging out');
    }
  }
}
