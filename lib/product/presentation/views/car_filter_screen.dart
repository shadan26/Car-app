import 'package:ecommerc_project/product/presentation/views/Product%20Views/user_home_page.dart';
import 'package:flutter/material.dart';
import '../../../constent.dart';
import '../../domain/entity/car_product_entity.dart';

class CarFilterScreen extends StatefulWidget {
  final void Function(BuildContext context) showFilterDialog;

  const CarFilterScreen({Key? key, required this.showFilterDialog}) : super(key: key);

  @override
  _CarFilterScreenState createState() => _CarFilterScreenState();
}

class _CarFilterScreenState extends State<CarFilterScreen> {
  List<Car>? selectedCarList;
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
      AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text('Filter Cars'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Model:'),
              DropdownButton<String>(
                value: selectedModel,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedModel = newValue!;
                  });
                },
                items: <String>[
                  '',
                  'Camry',
                  'Corolla',
                  'Prius',
                  // Add other models here
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Price:'),
              Slider(
                value: selectedPrice.toDouble(),
                min: 0,
                max: 10000,
                divisions: 15000,
                onChanged: (double value) {
                  setState(() {
                    selectedPrice = value.toInt();
                  });
                },
              ),
              Text('Brand:'),
              DropdownButton<String>(
                value: selectedBrand,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBrand = newValue!;
                  });
                },
                items: <String>[
                  '', // Empty option for no filter
                  'Toyota',
                  'Honda',
                  'Ford',
                  // Add other brands here
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),]
    );
  }
}
