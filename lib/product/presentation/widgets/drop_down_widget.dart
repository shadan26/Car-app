import 'package:flutter/material.dart';

import '../../../constent.dart';

class DropDownCategory extends StatefulWidget {

  const DropDownCategory({super.key});
  static String? selectedCategory;
  @override
  State<DropDownCategory> createState() => _DropDownCategoryState();
}

class _DropDownCategoryState extends State<DropDownCategory> {

  @override
  Widget build(BuildContext context) {
    return  DropdownButton<String>(
      hint: const Text('Select a category'),
      value:DropDownCategory.selectedCategory ,
      onChanged: (newValue) {
        setState(() {
          DropDownCategory.selectedCategory = newValue;
        });
      },
      items: [
        const DropdownMenuItem<String>(
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
    );
  }
}
