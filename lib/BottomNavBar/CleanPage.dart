// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CleanPage extends StatefulWidget {
  const CleanPage({Key? key});

  @override
  State<CleanPage> createState() => _CleanPageState();
}

class _CleanPageState extends State<CleanPage> {
  List<ListModel> lists = [
    ListModel("Daniel", "10:30", 0),
    ListModel("Chandru", "4:20 pm", 0),
    ListModel("Jaga", "3:20 am", 0),
    ListModel("Daniel", "3:30 pm", 0),
  ];
  increament(int index) {
    setState(() {
      lists[index].isLiked = !lists[index].isLiked;
      if (lists[index].isLiked) {
        lists[index].itemCount += 1;
      } else {
        lists[index].itemCount -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/clean-bg.jpg'), // Replace 'background_image.jpg' with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 125,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '“Make it Clean BOYS” ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 248, 245, 245)
                      .withOpacity(0.8399999737739563),
                  fontSize: (MediaQuery.of(context).size.width) / 14,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w700,
                  height: 0.04,
                  letterSpacing: 1.81,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                backgroundColor: Color(0xFF002D56),
                foregroundColor: Colors.white,
                fixedSize: Size(MediaQuery.of(context).size.width - 150, 50),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Clean();
                  },
                );
              },
              child: Text(
                'Submit Proof',
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width) / 22,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: lists.length, // Updated itemCount
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset(
                                'assets/dani.jpg',
                                fit: BoxFit.cover,
                              ),
                              ListTile(
                                title: Text(lists[index].name),
                                subtitle: Text(lists[index].desc),
                                trailing: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("Kitchen"),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              increament(index);
                                            },
                                            icon: Icon(Icons.favorite),
                                            color: lists[index].isLiked
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          Text(
                                              lists[index].itemCount.toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListModel {
  String name;
  String desc;
  int itemCount;
  bool isLiked = false;
  ListModel(this.name, this.desc, this.itemCount);
}

class Clean extends StatefulWidget {
  const Clean({super.key});

  @override
  State<Clean> createState() => _CleanState();
}

class _CleanState extends State<Clean> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  Uint8List? _image;
  File? selectedIMage;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    'Enter Cleaning Details?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF002D56),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: IconButton(
                      onPressed: () {
                        showImagePickerOption(context);
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 90,
                      )),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF002D56),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 2.5,
                        color: Color(0xFF002D56),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    hintText: "Enter Cleaned Place",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the place';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF002D56),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 2.5,
                        color: Color(0xFF002D56),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    hintText: "Cleaned With? (optional)",
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Color(0xFF002D56),
                    foregroundColor: Colors.white,
                    fixedSize: const Size(350, 50),
                  ),
                  onPressed: () async {
                    {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('SEND'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop(); //close the model sheet
  }

//Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }
}
