// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../domain/entity/car_product_entity.dart';

// class DetailView extends StatelessWidget {
//   const DetailView({super.key, required this.car});
//   final Car car;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
//         Image.network(car.imageName),
//         Text(car.model),
//         SizedBox(
//           height: 20,
//         ),
//         Text(
//           car.desecription,
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             car.price.toString(),
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         Text(
//           "call Me at: " + "  " + car.callMe,
//           style: TextStyle(color: Colors.blue),
//         )
//       ]),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../domain/entity/car_product_entity.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key, required this.car}) : super(key: key);

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              car.imageName,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              car.model,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              car.desecription,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Price: \$${car.price}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact: ${car.callMe}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
