// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);

  return '$formattedTime On\n$formattedDate';
}

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
                '“Make it Clean BOYS”',
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
            Flexible(
              child: FutureBuilder<void>(
                future:
                    Future.delayed(Duration(seconds: 1)), // Delay for 5 seconds
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(255, 247, 243, 243)),
                    ));
                  } else {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cleaning')
                          .orderBy('time_stamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return CleanCard(document: document, data: data);
                          }).toList(),
                        );
                      },
                    );
                  }
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
      color: Colors.white.withOpacity(0.8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.data['imageUrl'],
                fit: BoxFit.cover,
                // width: 300,
                height: 150,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "  & ${widget.data['cleaned-with']}",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            subtitle: Text(
              '${formattedTimestamp(widget.data['time_stamp'].toDate())}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.data['area'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
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
  String selectedCommunity = "";
  List<String> communityOptions = [
    "Dani",
    "Jega",
    "Harish",
    "Deepak",
    "chandru",
    "praveen",
  ];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  Uint8List? _image;
  File? selectedImage;
  final CollectionReference _clean =
      FirebaseFirestore.instance.collection('cleaning');
  String imageUrl = '';
  late User? _user;
  bool _isUploading = false;
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _fetchUser();
    requestPermission();
    getToken();
    initInfo();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied or not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    String googleUserName = _user?.displayName ?? 'temp';
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(googleUserName)
        .set({'token': token});
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      try {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print('Notification payload: ${response.payload}');
        }
      } catch (e) {
        print('Error handling notification response: $e');
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("-------------onMessage--------------");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: false,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['title'],
      );
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    print('Sending push message...');
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAAl1MZyY:APA91bEgx1_uPqDUdL5wSkIFFvmASSVJO2jXHXMtQ-BfiIpNaFIiaAAjaH_cooXlmsAAV7rfp1bYRHEB2AE7HjyZPIvVH_tfmdzQOUSfRjD1vIwqAMOTlO17jKoOMqlt0Tmg9obUCyjN'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'dbfood'
            },
            'to': token,
          },
        ),
      );
      print('Push message sent successfully');
    } catch (e) {
      print("push notification error: " + e.toString());
    }
  }

  Future<void> sendNotificationsToAllUsers(String body, String title) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("UserTokens").get();
      for (var doc in snapshot.docs) {
        String token = doc['token'];
        sendPushMessage(token, body, title);
      }
    } catch (e) {
      print("Error fetching user tokens: $e");
    }
  }

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
                    ? Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                        width: 300,
                        height: 150,
                      )
                    : Container(), // Show image preview if selected
                Container(
                  child: IconButton(
                      onPressed: () {
                        showImagePickerOption(context);
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                      )),
                ),
                Text("Click to upload image"),
                SizedBox(height: 16),
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
                DropdownButton<String>(
                  value: selectedCommunity,
                  hint: Text("Cleaned With"), // Hint for the dropdown
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child:
                          Text("Cleaned with"), // Displayed as the first item
                    ),
                    ...communityOptions.map((community) {
                      return DropdownMenuItem<String>(
                        value: community,
                        child: Text(community),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value!;
                    });
                  },
                  underline: Container(), // Remove the default underline
                  isExpanded: true,
                ),

                SizedBox(height: 16),
                _isUploading
                    ? CircularProgressIndicator() // Show circular progress indicator while uploading
                    : ElevatedButton(
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
                            setState(() {
                              _isUploading = true;
                            });
                            await sendToFirebase();
                            String googleUserName =
                                _user?.displayName ?? 'No Name';
                            String place = _titleController.text;
                            String notiBody = "cleaned :" + place;
                            String notiTitle = "Cleaned By " + googleUserName;
                            await sendNotificationsToAllUsers(
                                notiBody, notiTitle);
                            setState(() {
                              _isUploading = false;
                            });
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
        print('Selected Image: $_image');
        await uploadImageToStorage();
      }
      String googleUserName = _user?.displayName ?? 'No Name';

      await _clean.add({
        'name': googleUserName,
        'time_stamp': Timestamp.now(),
        'area': _titleController.text,
        'imageUrl': imageUrl,
        'likes': 0,
        'cleaned-with': selectedCommunity,
      });
    } catch (e) {
      print('Error sending to Firebase: $e');
    }
  }

  Future<void> uploadImageToStorage() async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('cleaning_images/$timestamp');
      final UploadTask uploadTask = storageReference.putFile(selectedImage!);
      setState(() {
        _isUploading = true;
      });
      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
        setState(() {
          _isUploading = false;
        });
      });
      print('Image URL: $imageUrl');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading image to Firebase Storage: $e');
    }
  }
}
