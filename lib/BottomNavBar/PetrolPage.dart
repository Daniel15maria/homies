// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);
  return '$formattedTime \n$formattedDate';
}

class PetrolPage extends StatefulWidget {
  const PetrolPage({Key? key}) : super(key: key);

  @override
  State<PetrolPage> createState() => _PetrolPageState();
}

class _PetrolPageState extends State<PetrolPage>
    with AutomaticKeepAliveClientMixin {
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/petrol-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Petrol History',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  backgroundColor: Color.fromARGB(255, 126, 102, 43),
                  foregroundColor: Colors.white,
                  fixedSize: Size(MediaQuery.of(context).size.width - 150, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PetrolDetails();
                    },
                  );
                },
                child: Text(
                  'Enter Details',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: FutureBuilder(
                future:
                    Future.delayed(Duration(seconds: 2)), // Delay for 2 seconds
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _petrol
                            .orderBy('time_stamp', descending: true)
                            .snapshots()
                            .distinct(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No data available'));
                          }

                          var documents = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var data = documents[index].data()
                                  as Map<String, dynamic>;
                              return Column(
                                children: [
                                  SizedBox(height: 5),
                                  Card(
                                    color: Colors.white.withOpacity(0.6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListTile(
                                        title: Text(
                                          data['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${formattedTimestamp(data['time_stamp'].toDate())}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Text(
                                          '₹ ${data['amount']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(data['photoUrl']),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
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

class PetrolDetails extends StatefulWidget {
  const PetrolDetails({Key? key}) : super(key: key);

  @override
  State<PetrolDetails> createState() => _PetrolDetailsState();
}

class _PetrolDetailsState extends State<PetrolDetails> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  TextEditingController _titleController = TextEditingController();
  late User? _user;
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
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  'Enter Details',
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
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF002D56)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(width: 2.5, color: Color(0xFF002D56)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  hintText: "Enter Amount",
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (int.parse(value) < 26) {
                    return 'Please fill petrol more than 25 rupees';
                  }
                  return null;
                },
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
                    var now = DateTime.now();
                    String googleUserName = _user?.displayName ?? 'No Name';
                    String userPhotoUrl = _user!.photoURL!;
                    int amt = int.parse(_titleController.text);
                    await _petrol.add({
                      'amount': amt,
                      'time_stamp': now,
                      'name': googleUserName,
                      'photoUrl': userPhotoUrl,
                    });
                    String notiBody = "for ₹" + amt.toString();
                    String notiTitle = "Petrol Filled by: " + googleUserName;
                    await sendNotificationsToAllUsers(notiBody, notiTitle);
                    Navigator.pop(context);
                  }
                },
                child: Text('SEND'),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
