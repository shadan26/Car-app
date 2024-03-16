import 'dart:io';

class Car {
  final String brand;
  final String model;
  final int year;
  final String color;
  final double price;
  final String description;
  late final String imageName;
  final String id;
  File? file;
  final String callMe;
  int createdAt;

  Car({required this.id
    ,required this.description,
      required this.brand,
        required this.model,
        required this.year,
        required this.color,
        required this.price,
        this.imageName = '',
        required this.createdAt,
  required this.callMe, required String desecription});
}




