import 'dart:io';

class Car {
  final String brand;
  final String model;
  final int year;
  final String color;
  final double price;
  final String description;
  late final String imageName;
  final num id;
  File? file;
  final String callMe;

  Car({required this.id
    ,required this.description,
      required this.brand,
        required this.model,
        required this.year,
        required this.color,
        required this.price,
        this.imageName = '',
        required this.callMe, required String desecription});


}




