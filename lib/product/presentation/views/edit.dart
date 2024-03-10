import 'dart:io';
import 'dart:math';

import 'package:ecommerc_project/product/presentation/views/show_product_view.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/widget/text_form_filed_widget.dart';
import '../../domain/entity/car_product_entity.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> productData; // Pass product data to the detail page
  const EditProduct({Key? key, required this.productData}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

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
                    'Edit proudct',
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

                        File file=File(xFile!.path);
                        Car model = Car(
                            id:(DateTime.now().millisecondsSinceEpoch)+(Random().nextInt(1000)),
                            model: modelTextEditingController.text,
                            brand: brandTextEditingController.text,
                            year: int.tryParse(yearTextEditingController.text) ?? 0,
                            color: colorTextEditingController.text,
                            price: double.tryParse(priceTextEditingController.text) ?? 0.0,
                            desecription: desecriptionTextEditingController.text,
                            callMe: callmeTextEditingController.text,
                            imageName: (await uploadImageToFirebaseStorage(file))!, description: ''
                        );
                        if (kDebugMode) {
                          print("MODELLL");
                        }
                        updateDocument(model);
                      },
                      style: ElevatedButton.styleFrom(),
                      child: const Text(
                        'Add',
                        style: TextStyle( fontSize: 16,
                          fontWeight: FontWeight.bold, color: Colors.blue,),
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
  void updateDocument(Car carModel) async {
    // Initialize Firebase

    // Reference to the collection
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('product');
    try {
      if (kDebugMode) {
        print(widget.productData['id']);
      }
      // Query for the document with name equal to "11"
      QuerySnapshot querySnapshot = await collectionReference.where('id', isEqualTo: widget.productData['id']).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the first matching document
        var documentId = querySnapshot.docs.first.id;

        // Update the document with new data
        await collectionReference.doc(documentId).update({
          "model": carModel.model,
          "brand": carModel.brand,
          'year': carModel.year,
          'color': carModel.color,
          'price': carModel.price,
          'desecription': carModel.description,
          'call': carModel.callMe,
          'imageNmae':carModel.imageName
          // Add other fields as needed
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShowProductView(),
            ));
        if (kDebugMode) {
          print('Document with ID $documentId updated successfully.');
        }
      } else {
        if (kDebugMode) {
          print('No document found with name equal to "11".');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
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
