// import 'dart:io';
// import 'dart:math';
//
// import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
// import 'package:ecommerc_project/product/presentation/views/Product%20Views/user_home_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../core/utils/widget/text_form_filed_widget.dart';
// import '../../domain/entity/car_product_entity.dart';
// import '../views/Product Views/Admin_home_page.dart';
//
// class EditProduct extends StatefulWidget {
//   final Map<String, dynamic> productData;
//   const EditProduct({Key? key, required this.productData}) : super(key: key);
//
//   @override
//   State<EditProduct> createState() => _EditProductState();
// }
//
// class _EditProductState extends State<EditProduct> {
//
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController brandTextEditingController = TextEditingController();
//   TextEditingController modelTextEditingController = TextEditingController();
//   TextEditingController yearTextEditingController = TextEditingController();
//   TextEditingController colorTextEditingController = TextEditingController();
//   TextEditingController priceTextEditingController = TextEditingController();
//   TextEditingController desecriptionTextEditingController = TextEditingController();
//   TextEditingController callmeTextEditingController = TextEditingController();
//
//   String? errorMassage;
//   FirebaseAuth? firebaseAuth;
//   XFile? xFile;
//
//   @override
//   void dispose() {
//     brandTextEditingController.dispose();
//     modelTextEditingController.dispose();
//     colorTextEditingController.dispose();
//     priceTextEditingController.dispose();
//     desecriptionTextEditingController.dispose();
//     callmeTextEditingController.dispose();
//     yearTextEditingController.dispose();
//
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery
//         .of(context)
//         .size
//         .width;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           scrollDirection: Axis.vertical,
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Edit proudct',
//                     style: GoogleFonts.poppins(
//                       textStyle: const TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 7),
//                   _getProfileImageView(),
//                   TextFiledWidget(
//                     controller: brandTextEditingController,
//                     labelText: 'brand',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: modelTextEditingController,
//                     labelText: 'model',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: yearTextEditingController,
//                     labelText: 'year',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: colorTextEditingController,
//                     labelText: 'color',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: priceTextEditingController,
//                     labelText: 'price',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: desecriptionTextEditingController,
//                     labelText: 'desecription',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFiledWidget(
//                     controller: callmeTextEditingController,
//                     labelText: 'call',
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: width,
//                     height: 40,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         File file = File(xFile!.path);
//                         var car = Car(
//                             id: Uuid().v1(),
//                             model: modelTextEditingController.text,
//                             brand: brandTextEditingController.text,
//                             year: int.tryParse(
//                                 yearTextEditingController.text) ?? 0,
//                             color: colorTextEditingController.text,
//                             price: double.tryParse(
//                                 priceTextEditingController.text) ?? 0.0,
//                             desecription: desecriptionTextEditingController
//                                 .text,
//                             callMe: callmeTextEditingController.text,
//                             imageName: (await FirebaseManager()
//                                 .uploadImageToFirebaseStorage(file))!,
//                             description: '',
//                             createdAt: DateTime
//                                 .now()
//                                 .millisecondsSinceEpoch
//                         );
//                         await FirebaseManager().editProduct(car);
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (
//                                   context) => const ShowAdminProductView(),
//                             ));
//                       },
//                       style: ElevatedButton.styleFrom(),
//                       child: const Text(
//                         'Add',
//                         style: TextStyle(fontSize: 16,
//                           fontWeight: FontWeight.bold, color: Colors.blue,),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _getProfileImageView() {
//     return Center(
//       child: InkWell(
//         onTap: () async {
//           ImagePicker picker = ImagePicker();
//           xFile = await picker.pickImage(source: ImageSource.camera); // permission
//           setState(() {});
//         },
//         child: Container(
//           width: 150,
//           height: 100,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.black, width: 3),
//           ),
//           child: Center(
//               child: xFile == null
//                   ? const Icon(Icons.photo)
//                   : ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: Image.file(
//                   File(xFile!.path),
//                   fit: BoxFit.cover,
//                 ),
//               )),
//         ),
//       ),
//     );
//   }
// }