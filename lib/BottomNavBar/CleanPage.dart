// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CleanPage extends StatelessWidget {
  const CleanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/clean-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 125),
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
            SizedBox(height: 25),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cleaning')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return CleanCard(document: document, data: data);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CleanCard extends StatefulWidget {
  final DocumentSnapshot document;
  final Map<String, dynamic> data;

  const CleanCard({
    Key? key,
    required this.document,
    required this.data,
  }) : super(key: key);

  @override
  State<CleanCard> createState() => _CleanCardState();
}

class _CleanCardState extends State<CleanCard> {
  bool isLiked = false;
  int likesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/dani.jpg',
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(widget.data['name']),
            // subtitle: Text(data['time_stamp']),
            trailing: SingleChildScrollView(
              child: Column(
                children: [
                  Text(widget.data['area']),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: isLiked ? Colors.blue : Colors.grey,
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                            if (isLiked) {
                              likesCount++;
                              incrementLikes(widget.document.id, likesCount);
                            } else {
                              likesCount--;
                              incrementLikes(widget.document.id, likesCount);
                            }
                          });
                        },
                      ),
                      Text(widget.data['likes'].toString())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> incrementLikes(String documentId, int likes) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('cleaning').doc(documentId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception('Document does not exist!');
      }

      transaction.update(documentReference, {'likes': likes});
    });
  }
}

class Clean extends StatefulWidget {
  const Clean({Key? key});

  @override
  State<Clean> createState() => _CleanState();
}

class _CleanState extends State<Clean> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  Uint8List? _image;
  File? selectedImage;
  final CollectionReference _clean =
      FirebaseFirestore.instance.collection('clean');
  String imageUrl = '';

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
                selectedImage != null
                    ? Image.file(selectedImage!)
                    : Container(), // Show image preview if selected
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
                    if (_formKey.currentState!.validate()) {
                      await sendToFirebase();
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
      selectedImage = File(returnImage.path);
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
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  Future<void> sendToFirebase() async {
    try {
      if (_image != null) {
        await uploadImageToStorage();
      }
      await _clean.add({
        'name': _titleController.text,
        'time': Timestamp.now(),
        'cleanedPlace': _messageController.text,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error sending to Firebase: $e');
    }
  }

  Future<void> uploadImageToStorage() async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('cleaning_images');
      final UploadTask uploadTask = storageReference.putFile(selectedImage!);
      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
      });
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }
}
