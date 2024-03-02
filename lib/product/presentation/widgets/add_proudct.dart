import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerc_project/constent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/widget/text_form_filed_widget.dart';

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

  FirebaseAuth? firebaseAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        var collection =
                            FirebaseFirestore.instance.collection('product');
                        await collection.add({
                          "model": modelTextEditingController.text,
                          "brand": brandTextEditingController.text,
                          'year': yearTextEditingController,
                          'color': colorTextEditingController.text,
                          'price': priceTextEditingController.text,
                          'desecription': desecriptionTextEditingController.text,
                          'call': desecriptionTextEditingController.text,
                        });
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
}
