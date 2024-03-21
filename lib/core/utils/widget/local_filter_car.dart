import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  FilterDialog extends StatefulWidget {
  late String selectedModel;
  late int ?selectedPrice;
  late String selectedBrand;

  FilterDialog({
    this.selectedModel="",
  this.selectedPrice,
     this.selectedBrand="",
  }

  ) ;

  @override
  _FilterDialogState createState() => _FilterDialogState(selectedModel:selectedModel,  selectedBrand: selectedBrand);
}


class _FilterDialogState extends State<FilterDialog> {
  String selectedModel = '';
  int selectedPrice = 0;
  String selectedBrand = '';

  _FilterDialogState({
     this.selectedModel="",
    this.selectedPrice=0,
     this.selectedBrand="",
  }) ;

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  Future<void> loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedModel = prefs.getString('selectedModel') ?? '';
      selectedPrice = prefs.getInt('selectedPrice') ?? 0;
      selectedBrand = prefs.getString('selectedBrand') ?? '';
    });
  }

  Future<void> saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedModel', selectedModel);
    await prefs.setInt('selectedPrice', selectedPrice);
    await prefs.setString('selectedBrand', selectedBrand);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              max: 50000,
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
            saveFilters();
            Navigator.of(context).pop({
              'model': selectedModel,
              'price': selectedPrice,
              'brand': selectedBrand,
            });

            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>  LocalResultsWidget (selectedModel: selectedModel, selectedPrice: selectedPrice, selectedBrand: selectedBrand,)));
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class LocalResultsWidget extends StatefulWidget   {
 String ?selectedModel;
  int ?selectedPrice;
  String ?selectedBrand;

 LocalResultsWidget({
     this.selectedModel,
    this.selectedPrice,
     this.selectedBrand,
    Key? key,
  }) : super(key: key);

  @override
  _LocalResultsWidgetState createState() => _LocalResultsWidgetState(selectedModel: selectedModel.toString(), selectedPrice: selectedPrice!.toInt(), selectedBrand: selectedBrand.toString());
}

class _LocalResultsWidgetState extends State<LocalResultsWidget> {

  late String selectedModel;
  late int selectedPrice;
  late String selectedBrand;
  _LocalResultsWidgetState({
    required this.selectedModel,
    required this.selectedPrice,
    required this.selectedBrand,
  });

  List<Map<String, dynamic>> filteredCars = [
    {
      'brand': 'Toyota',
      'model': 'Camry',
      'price': 25000,
    },
    {
      'brand': 'Toyota',
      'model': 'Corolla',
      'price': 20000,
    },
    {
      'brand': 'Honda',
      'model': 'Accord',
      'price': 28000,
    },
  ];

  List<Map<String, dynamic>> filteredCarsResult = [];

  @override
  void initState() {
    super.initState();
    getData(selectedModel, selectedPrice, selectedBrand);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local filter results'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredCarsResult.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredCarsResult[index]['model']),
                  subtitle: Text(filteredCarsResult[index]['brand']),
                  trailing: Text('\$${filteredCarsResult[index]['price'].toString()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getData(String model, int price, String brand) {
  for(int i=0 ; i<filteredCars.length; i++) {
    if(model == filteredCars[i]['model']
    && (brand == filteredCars[i]['brand'])
    && (price <= filteredCars[i]['price'])) {
      filteredCarsResult.add(filteredCars[i]);
      setState(() {});
    }
  }
  }
}



