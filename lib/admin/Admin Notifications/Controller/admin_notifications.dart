import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/admin/Admin%20Notifications/Views/Widget/list_of_notifications.dart';
import 'package:flutter/material.dart';

import '../../../core/Firebase/FirebaseManager.dart';

class AdminNotifications extends StatefulWidget {

   const AdminNotifications ({super.key , });

  @override
  State<AdminNotifications> createState() => _State();
}

class _State extends State<AdminNotifications> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  ListofNotifications notificationsList = ListofNotifications();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Notifications"),
            centerTitle: true,
          ),

          body: Expanded(
              child:StreamBuilder<QuerySnapshot>(
                  stream: FirebaseManager().getNotificationsForAdmin(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                      notificationsList.docs = snapshot.data?.docs;
                    return notificationsList;
                  } )
          ),
        ));
  }
}
