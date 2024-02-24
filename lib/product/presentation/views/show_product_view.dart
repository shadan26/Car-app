import 'package:flutter/material.dart';
import '../../domain/entity/car_product_entity.dart';
import 'package:ecommerc_project/constent.dart';

import '../widgets/drop_down_widget.dart';
import 'detail_product_view.dart';

class ShowProductView extends StatefulWidget {
  const ShowProductView({Key? key}) : super(key: key);

  @override
  State<ShowProductView> createState() => _ShowProductViewState();
}

class _ShowProductViewState extends State<ShowProductView> {

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<Car> products= selectedCategory==null?
    carList :
    carList.where((element) => element.brand==selectedCategory).toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text("homepage"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.canPop(context);
            },
          ),
        ),
        body: Column(
          children: [
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select a category'),
              value:selectedCategory ,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: '',
                  child: Text('all'),
                ),
                ...carInfo.map((car) {
                  return DropdownMenuItem<String>(
                    value: car["carText"],
                    child: Text(car["carText"]),
                  );
                }).toList(),
              ],
            ),
            Expanded(
              child:  GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => DetailView(car:products[index]),));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            products[index].imageName,
                            height: 60,
                          ),
                          Text(
                            products[index].brand + " " + products[index].model,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              products[index].price.toString() + "\$",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
              ,
            ),
          ],
        ),
      ),
    );
  }
}


