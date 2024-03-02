import 'package:flutter/material.dart';

import '../../../constent.dart';
import '../../domain/entity/car_product_entity.dart';
import 'drop_down_widget.dart';

class GridViewProduct extends StatelessWidget {
  const GridViewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    List<Car> products=  DropDownCategory.selectedCategory==null?
    carList :
    carList.where((element) => element.brand==DropDownCategory.selectedCategory).toList();
    return  GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(30),
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
                "${products[index].brand} ${products[index].model}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${products[index].price}\$",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ) ;
  }
}

