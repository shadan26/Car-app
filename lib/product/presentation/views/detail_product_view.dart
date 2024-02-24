import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/car_product_entity.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.car});
  final Car car ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Image.network(car.imageName),Text(car.model)
      ]) ,
    );
  }
}
