import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dbhelper.dart';
import 'List.dart';
import 'models.dart';

class addMov extends StatefulWidget {
  @override
  State<addMov> createState() => _addMovState();
}

class _addMovState extends State<addMov> {
  final _formkey = GlobalKey<FormState>();
  String mov_name = "";
  String dir_name = "";
  File? image;


  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
          automaticallyImplyLeading: false,
        title: Text("Add your movie"),
      ),
      body: Center(
        child: Form(
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              key: _formkey,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    color: Colors.black,
                    height: 500,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image != null
                            ? Image.file(
                                image!,
                                height: 200,
                                width: 150,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () =>
                                      pickImage(ImageSource.gallery),
                                  child: Container(
                                    color: Colors.white,
                                    height: 200,
                                    width: 150,
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Name cannot be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Movie Name',
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  mov_name = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Director name cannot be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Director Name',
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  dir_name = value;
                                });
                              },
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              String? image1 = image?.path;
                              String imagepath = "$image1";
                              File imagefile = File(imagepath); //convert Path to File
                              Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
                              String base64string = base64.encode(imagebytes); //convert bytes to base64 string

                              await DatabaseHandler()
                                  .inserttodo(todo(
                                      title: mov_name,
                                      description: dir_name,
                                      id: Random().nextInt(50),
                                      photo: base64string))
                                  .whenComplete(() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ListScreen()),
                              ));
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white,fontSize: 15),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
