import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constent.dart';

class DropDownCategory extends StatefulWidget {

  const DropDownCategory({super.key});
  static String? selectedCategory;//اقدر اوصل ل القمية من اي مكان ازا عرفتها ststic
  @override
  State<DropDownCategory> createState() => _DropDownCategoryState();
}

class _DropDownCategoryState extends State<DropDownCategory> {

  @override
  Widget build(BuildContext context) {
    return  DropdownButton<String>(
      hint: Text('Select a category'),
      value:DropDownCategory.selectedCategory ,
      onChanged: (newValue) {
        setState(() {
          DropDownCategory.selectedCategory = newValue;
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
    );
  }
}
