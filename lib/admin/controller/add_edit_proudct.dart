import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/Firebase/FirebaseManager.dart';
import '../../../core/utils/widget/text_form_filed_widget.dart';
import '../../core/utils/widget/button_widget.dart';
import '../../product/domain/entity/car_product_entity.dart';
import '../view/screens/admin_home_page.dart';


class AddEditProduct extends StatefulWidget {
  const AddEditProduct({Key? key, required this.productActionType, this.productData}) : super(key: key);
  final ProductActionType productActionType; // add, edit
  final Map<String, dynamic>? productData; // for edit

  @override
  State<AddEditProduct> createState() => _AddEditProductState(productActionType, productData);
}

enum ProductActionType {
  add,
  edit
}

class _AddEditProductState extends State<AddEditProduct> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController brandTextEditingController = TextEditingController();
  TextEditingController modelTextEditingController = TextEditingController();
  TextEditingController yearTextEditingController = TextEditingController();
  TextEditingController colorTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController desecriptionTextEditingController = TextEditingController();
  TextEditingController callmeTextEditingController = TextEditingController();

  XFile? xFile;
  ProductActionType? actionType;
  Map<String, dynamic>? productData;
  bool _isLoading = false;

  _AddEditProductState(ProductActionType this.actionType, Map<String, dynamic>? this.productData);

  @override
  void initState() {
    super.initState();
    if(actionType == ProductActionType.edit) {
      brandTextEditingController.text = productData?['brand'];
      modelTextEditingController.text = productData?['model'];
      colorTextEditingController.text = productData?['color'];
      priceTextEditingController.text = '${productData?['price']}';
      desecriptionTextEditingController.text = productData?['description'];
      callmeTextEditingController.text = productData?['call'];
      yearTextEditingController.text = '${productData?['year']}';
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

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

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
                   actionType == ProductActionType.add ? 'Add product' : 'Edit product',
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
                    labelText: 'description',
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
                    child: MyButton (
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Show loading indicator
                        });
                        File file = File(xFile!.path);
                        var car = Car(
                            id: ( const Uuid().v1()),
                            model: modelTextEditingController.text,
                            brand: brandTextEditingController.text,
                            year: int.tryParse(yearTextEditingController.text) ?? 0,
                            color: colorTextEditingController.text,
                            price: double.tryParse(priceTextEditingController.text) ?? 0.0,
                            desecription: desecriptionTextEditingController.text,
                            callMe: desecriptionTextEditingController.text,
                            imageName: (await uploadImageToFirebaseStorage(file))!,
                            description: '', createdAt: DateTime.now().millisecondsSinceEpoch);
                        if (actionType == ProductActionType.add) {
                          await FirebaseManager().addCar(car);
                        } else {
                          await FirebaseManager().editCar(car);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowAdminProductView()
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(),
                      child:  _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                        actionType == ProductActionType.add ? 'Add' : "Edit",
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
              child:
              xFile == null
                  ? actionType == ProductActionType.edit ?
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(productData?["imageName"],
                  fit: BoxFit.cover,
                ),
              ) : const Icon(Icons.photo)
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