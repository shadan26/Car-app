import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/widget/firebase_filter_car.dart';
import '../widget/list_of_admin.dart';
import '../../../core/utils/widget/local_filter_car.dart';
import '../../../product/domain/entity/car_product_entity.dart';
import '../../../product/presentation/views/authentication/login_screen.dart';
import '../../controller/add_edit_proudct.dart';

class ShowAdminProductView extends StatefulWidget {
  const ShowAdminProductView({Key? key}) : super(key: key);

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
  var currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

  var Scaffoldkey = GlobalKey<ScaffoldState>();


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
              icon: const Icon(Icons.refresh, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return Carfilter();
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
                      builder: (context) => const AddEditProduct(productActionType: ProductActionType.add,),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            const SizedBox(height: 10),
          ],
        ),
        body: Expanded(
          child: Listofadmin(),
        ),
      ),
    );

  }

  void handleLogout(BuildContext context) async {
    await FirebaseManager().logout();
    runApp(
        MaterialApp(
          home: LoginScreen(),
        )
    );
    Navigator.push(
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




