import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../product/domain/entity/car_product_entity.dart';
import '../../controller/add_edit_proudct.dart';
import '../../../product/presentation/views/detail_product_view.dart';
import '../../../core/Firebase/FirebaseManager.dart';

class Listofadmin extends StatefulWidget {

    late List<QueryDocumentSnapshot<Object?>>? docs;

   Listofadmin({Key? key, this.docs}) : super(key: key);

  @override
  State<Listofadmin> createState() => _ListofadminState();
}

class _ListofadminState extends State<Listofadmin> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();

    if (widget.docs != null && widget.docs!.isNotEmpty) {
      data = widget.docs![0].data() as Map<String, dynamic>;
    } else {
      data = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: widget.docs?.length,
      itemBuilder: (BuildContext context, int index) {
        var data = widget.docs?[index].data()
        as Map<String, dynamic>;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailPage(productData: data),
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
              color: Colors.white,
              child: ListTile(
                leading: Image.network(
                  data['imageName'],
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
                      "${data['model']} ${data['brand']}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "${data?['price']}\$",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return AddEditProduct(productActionType: ProductActionType.edit, productData: data); //EditProduct(productData: data);
                                })).then((value) => {
                                  setState(() {
                                    var editedCar = value as Car;
                                    data['id'] = editedCar.id;
                                    data['model'] = editedCar.model;
                                    data['brand'] = editedCar.brand;
                                    data['price'] = editedCar.price;
                                    data['call'] = editedCar.callMe;
                                    data['imageName'] = editedCar.imageName;
                                    data['year'] = editedCar.year;
                                    data['description']=editedCar.description;
                                    data["color"]=editedCar.color;
                                  })
                        });
                      },
                      icon: const Icon(Icons.edit,
                          color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseManager().removeCar(data['id']);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                    ),
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
