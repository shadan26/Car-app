import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entity/car_product_entity.dart';
import 'package:ecommerc_project/constent.dart';
import '../widgets/add_proudct.dart';
import 'detail_product_view.dart';

class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {
  String? selectedCategory;

  @override
  Future<void> initState() async {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    List<Car> products = selectedCategory == null
        ? carList
        : carList
            .where((element) => element.brand == selectedCategory)
            .toList();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(),
                ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text("homepage"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.canPop(context);
            },
          ),
        ),
        body:
          StreamBuilder(
            builder: (context, snapshot) {
              return Text("");


      //       }, stream:  FirebaseFirestore.instance.collection('product')
      //     collection.snapshots().map((event) => event.docs.map((doc) => Car(
      //   brand: doc['brand'],
      //   model: doc['model'],
      //   year: doc['year'],
      //   color: doc['color'],
      //   price: doc['price'],
      //   //imageName: doc['price'],
      //   desecription: doc['desecription'],
      //   callMe: doc['call'],
      // )).toList());,
          )

        // Column(
        //   children: [
        //     DropdownButton<String>(
        //       isExpanded: true,
        //       hint: const Text('Select a category'),
        //       value: selectedCategory,
        //       onChanged: (newValue) {
        //         setState(() {
        //           selectedCategory = newValue;
        //         });
        //       },
        //       items: [
        //         const DropdownMenuItem<String>(
        //           value: '',
        //           child: Text('all'),
        //         ),
        //         ...carInfo.map((car) {
        //           return DropdownMenuItem<String>(
        //             value: car["carText"],
        //             child: Text(car["carText"]),
        //           );
        //         }).toList(),
        //       ],
        //     ),
        //     Expanded(
        //       child: GridView.builder(
        //         itemCount: products.length,
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           crossAxisSpacing: 10,
        //           mainAxisSpacing: 10,
        //         ),
        //         itemBuilder: (context, index) {
        //           return InkWell(
        //             onTap: () {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) =>
        //                         DetailView(car: products[index]),
        //                   ));
        //             },
        //             child: Container(
        //               padding: const EdgeInsets.all(5),
        //               // margin: EdgeInsets.all(18),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.white,
        //               ),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 children: [
        //                   Image.network(
        //                     products[index].imageName,
        //                     errorBuilder: (context, error, stackTrace) {
        //                       return const Icon(
        //                           Icons.error); // Display error icon
        //                     },
        //                   ),
        //                   Text(
        //                     "${products[index].brand} ${products[index].model}",
        //                     style: const TextStyle(
        //                       fontSize: 15,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                   const SizedBox(height: 10),
        //                   Align(
        //                     alignment: Alignment.bottomLeft,
        //                     child: Text(
        //                       "${products[index].price}\$",
        //                       style: const TextStyle(
        //                         fontSize: 10,
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.red,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
