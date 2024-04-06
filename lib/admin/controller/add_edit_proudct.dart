import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/Firebase/FirebaseManager.dart';
import '../../../core/utils/widget/text_form_filed_widget.dart';
import '../../product/domain/entity/car_product_entity.dart';

class AddEditProduct extends StatefulWidget {
  const AddEditProduct(
      {Key? key, required this.productActionType, this.productData})
      : super(key: key);
  final ProductActionType productActionType;
  final Map<String, dynamic>? productData;

  @override
  State<AddEditProduct> createState() =>
      _AddEditProductState(productActionType, productData);
}

enum ProductActionType { add, edit }

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  double _price = 50.0;
  final double _minPrice = 0.0;
  final double _maxPrice = 25000;

  FocusNode brandFocusNode = FocusNode();
  FocusNode modelFocusNode = FocusNode();
  FocusNode yearFocusNode = FocusNode();
  FocusNode colorFocusNode = FocusNode();
  FocusNode desecriptionFocusNode = FocusNode();
  FocusNode callmefocusNode = FocusNode();

  TextEditingController brandTextEditingController = TextEditingController();
  TextEditingController modelTextEditingController = TextEditingController();
  TextEditingController yearTextEditingController = TextEditingController();
  TextEditingController colorTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController desecriptionTextEditingController =
      TextEditingController();
  TextEditingController callmeTextEditingController = TextEditingController();

  XFile? xFile;
  ProductActionType? actionType;
  Map<String, dynamic>? productData;
  bool _isLoading = false;


  _AddEditProductState(ProductActionType this.actionType,
      this.productData);
  @override
  void initState() {
    super.initState();
    if (actionType == ProductActionType.edit) {
      brandTextEditingController.text = productData?['brand'];
      modelTextEditingController.text = productData?['model'];
      colorTextEditingController.text = productData?['color'];
      priceTextEditingController.text = '${productData?['price']}';
      desecriptionTextEditingController.text = productData?['description'];
      callmeTextEditingController.text = '+962${productData?['call']}';
      yearTextEditingController.text = '${productData?['year']}';
    } else {
      callmeTextEditingController.text = "+962";
    }
  }

  @override
  void dispose() {
    brandTextEditingController.dispose();
    modelTextEditingController.dispose();
    colorTextEditingController.dispose();
    priceTextEditingController.dispose();
    desecriptionTextEditingController.dispose();
    callmeTextEditingController.dispose();
    yearTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actionType == ProductActionType.add
                        ? 'Add product'
                        : 'Edit product',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  _getProfileImageView(),
                  TextFiledWidget(
                    controller: brandTextEditingController,
                    labelText: 'brand',
                    focusNode: brandFocusNode,
                    nextFocusNode: modelFocusNode,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    // onFieldSubmitted: (v){
                    //   FocusScope.of(context).requestFocus(focus);
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter brand name';
                      }
                      return null;
                    },
                    //nextFocusNode: modelFocusNode,
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: modelTextEditingController,
                    labelText: 'model',
                    focusNode: modelFocusNode,
                    nextFocusNode: yearFocusNode,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter model name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: yearTextEditingController,
                    labelText: 'year',
                    focusNode: yearFocusNode,
                    nextFocusNode: colorFocusNode,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      int? intValue = int.tryParse(value);
                      if (intValue == null || intValue <= 2010) {
                        return 'Please enter a value greater than 2010';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: colorTextEditingController,
                    focusNode:colorFocusNode,
                    nextFocusNode:desecriptionFocusNode,
                    textInputAction: TextInputAction.next,
                    labelText: 'color',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter color ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _price,
                        onChanged: (newValue) {
                          setState(() {
                            _price = newValue;
                          });
                        },

                        min: _minPrice,
                        max: _maxPrice,
                        divisions: _maxPrice.toInt() - _minPrice.toInt(),
                        label: _price.toStringAsFixed(2),
                      ),
                    ],
                  )


                 , const SizedBox(height: 16),
                  Padding(
                    
                    padding: EdgeInsets.all(30),
                    child: Container(
                        width: 300,
                        height: 200,
                      
                      child: TextFiledWidget(
                    
                        controller: desecriptionTextEditingController,
                        labelText: 'description',
                       maxLines: 1000,
                       maxLength: 200,

                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200),
                        ],

                        decoration: InputDecoration(
                          labelText: 'Description',
                          counterText: desecriptionTextEditingController.text.length.toString() + '/200',
                          counterStyle: TextStyle(
                            color: desecriptionTextEditingController.text.length == 200
                                ? Colors.red
                                : null,
                          ),
                        ),
                      keyboardType: TextInputType.multiline,
                        focusNode: desecriptionFocusNode,
                        nextFocusNode: callmefocusNode,
                        textInputAction: TextInputAction.next,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your description ';
                        }
                        return null;
                      },
                      )
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: callmeTextEditingController,
                    labelText: 'call',
                    keyboardType: TextInputType.phone,
                    focusNode: callmefocusNode,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter call number  ';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: ElevatedButton(



                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                          setState(() {
                          _isLoading = true;
                        });

                        var uniqueId = const Uuid().v1();
                        var car = Car(
                            id: actionType == ProductActionType.add ? uniqueId : productData?['id'],
                            model: modelTextEditingController.text,
                            brand: brandTextEditingController.text,
                            year: int.tryParse(yearTextEditingController.text) ?? 0,
                            color: colorTextEditingController.text,
                            price: double.tryParse(
                                    priceTextEditingController.text) ?? 0.0,
                            desecription: desecriptionTextEditingController.text,
                            callMe: desecriptionTextEditingController.text,
                            imageName: xFile != null
                                ? (await uploadImageToFirebaseStorage(File(xFile!.path)))!
                                : productData?["imageName"],
                            description: '',
                            createdAt: DateTime.now().millisecondsSinceEpoch);
                        if (actionType == ProductActionType.add) {
                          await FirebaseManager().addCar(car);
                        } else {
                          await FirebaseManager().editCar(car);
                        }

                        Navigator.pop(context, car);
                      }},
                      style: ElevatedButton.styleFrom(),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              actionType == ProductActionType.add
                                  ? 'Add'
                                  : "Edit",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/$fileName.jpg");
      await storageRef.putFile(imageFile);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Firebase Storage: $e');
      }
      return null;
    }
  }

  Widget _getProfileImageView() {
    return Center(
      child: InkWell(
        onTap: () async {
          ImagePicker picker = ImagePicker();
          xFile =
              await picker.pickImage(source: ImageSource.gallery); // permission
          setState(() {});
        },
        child: Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Center(
              child: xFile == null
                  ? actionType == ProductActionType.edit
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            productData?["imageName"],
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.photo)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(xFile!.path),
                        fit: BoxFit.cover,
                      ),
                    )),
        ),
      ),
    );
  }
}
