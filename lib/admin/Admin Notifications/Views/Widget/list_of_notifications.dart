import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:flutter/material.dart';

import '../../Controller/admin_notification_details.dart';

class ListofNotifications extends StatefulWidget {

  List<QueryDocumentSnapshot<Object?>>? docs;
  ListofNotifications({Key? key, this.docs});

  @override
  State<ListofNotifications> createState() => _ListofadminState();
}

class _ListofadminState extends State<ListofNotifications> {

  @override
  void initState() {
    FirebaseManager().viewNotifications().then((value) => {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: widget.docs?.length,
      itemBuilder: (BuildContext context, int index) {
        final data = widget.docs?[index].data()
        as Map<String, dynamic>;
        return InkWell(
          onTap: () {
            FirebaseManager().readNotification(data["id"]).then((value) => {
            setState(() {
              data["isOpened"] = true;
            })
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotificationDetailPage(notificationData: data),
              ),
            );
          },
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Card(
              color: data["isOpened"] ? Colors.white : Colors.grey,
              child: ListTile(
                leading: Image.network(
                  data['imageURL'],
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "${data['body']}\$",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                     "${data['createdAt']}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
