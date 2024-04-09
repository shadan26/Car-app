import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../domain/entity/notficiation_data.dart';

FlutterPhoneDirectCaller?flutterPhoneDirectCaller;
class ProductDetailPage extends StatelessWidget {

  final Map<String, dynamic> productData;

  const ProductDetailPage({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              productData['imageName'],
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 10),

            Text(
              '${productData['model']} ${productData['brand']}',
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${productData['description']}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {

                try {
                  await FlutterPhoneDirectCaller.callNumber(productData['call']);
                } on MissingPluginException catch (e) {
                  if (kDebugMode) {
                    print('Plugin implementation is missing: $e');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Phone call feature is not available.'),
                    ),
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print('Error calling phone number: $e');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('An error occurred while calling the phone number.'),
                    ),
                  );
                }
              },
              child: Text(
                'Call: +962 ${productData['call']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
              onPressed: () async {



                FirebaseManager().sendPushNotificationTopic("admin");

               var userData = await FirebaseManager().getUserData();
                var title = "New order";
                var body = productData['model'];
                var userEmail = userData.email;
                var userId = userData.id;
                var imageURL = productData["imageName"];
                var createdAt = DateTime.now().millisecondsSinceEpoch;

                var notificationToAdd = NotificationData(
                    title: title,
                    body: body,
                    userEmail: userEmail,
                    createdAt: createdAt,
                    userId: userId,
                    imageURL: imageURL,
                    isOpened: false,
                  isViewed: false
                );

                FirebaseManager().addNotification(notificationToAdd);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("We sent a message for admin"),
                  ),
                );
              },
                  child: const Text('Rent a Car' ,style: TextStyle(color: Colors.black87),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


