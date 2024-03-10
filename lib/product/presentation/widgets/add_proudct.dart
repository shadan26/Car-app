import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/widget/text_form_filed_widget.dart';
import '../../domain/entity/car_product_entity.dart';
import '../views/show_product_view.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController brandTextEditingController = TextEditingController();
  TextEditingController modelTextEditingController = TextEditingController();
  TextEditingController yearTextEditingController = TextEditingController();
  TextEditingController colorTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController desecriptionTextEditingController = TextEditingController();
  TextEditingController callmeTextEditingController = TextEditingController();

  String? errorMassage;
  XFile? xFile;
  FirebaseAuth? firebaseAuth;

  @override
  void dispose() {
    brandTextEditingController.dispose();
    modelTextEditingController.dispose();
    colorTextEditingController.dispose();
    priceTextEditingController.dispose();
    desecriptionTextEditingController.dispose();
    callmeTextEditingController.dispose();
    yearTextEditingController.dispose();

    // TODO: implement dispose
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
                    'Add proudct',
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
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: modelTextEditingController,
                    labelText: 'model',
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: yearTextEditingController,
                    labelText: 'year',
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: colorTextEditingController,
                    labelText: 'color',
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: priceTextEditingController,
                    labelText: 'price',
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: desecriptionTextEditingController,
                    labelText: 'desecription',
                  ),
                  const SizedBox(height: 16),
                  TextFiledWidget(
                    controller: callmeTextEditingController,
                    labelText: 'call',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        File file = File(xFile!.path);
                        Car model = Car(
                            id: (DateTime.now().millisecondsSinceEpoch) +
                                (Random().nextInt(1000)),
                            model: modelTextEditingController.text,
                            brand: brandTextEditingController.text,
                            year: int.tryParse(yearTextEditingController.text) ?? 0,
                            color: colorTextEditingController.text,
                            price: double.tryParse(priceTextEditingController.text) ?? 0.0,
                            desecription: desecriptionTextEditingController.text,
                            callMe: desecriptionTextEditingController.text,
                            imageName: (await uploadImageToFirebaseStorage(file))!,
                            description: '');

                        _saveProductFirestore(model);
                      },
                      style: ElevatedButton.styleFrom(),
                      child: const Text(
                        'Add',
                        style: TextStyle(
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

  void _saveProductFirestore(Car carModel) async {
    try {
      var collection = FirebaseFirestore.instance.collection('product');

      await collection.add({
        "id": carModel.id,
        "model": modelTextEditingController.text,
        "brand": brandTextEditingController.text,
        'year': yearTextEditingController.text,
        'color': colorTextEditingController.text,
        'price': priceTextEditingController.text,
        'desecription': desecriptionTextEditingController.text,
        'call': desecriptionTextEditingController.text,
        'imageNmae': carModel.imageName
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShowProductView(),
          ));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      if (error is FirebaseException) {
        if (kDebugMode) {
          print(error.code);
        }
      }
    }
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child("images/$fileName.jpg");
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
          xFile = await picker.pickImage(source: ImageSource.camera); // permission
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
                  ? const Icon(Icons.photo)
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
