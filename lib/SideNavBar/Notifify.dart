// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);

  return '$formattedTime \n$formattedDate';
}

class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  late Stream<QuerySnapshot> _notifyStream;
  final CollectionReference _notify =
      FirebaseFirestore.instance.collection('notify');
  List<bool> _buttonStates = [];

  @override
  void initState() {
    super.initState();
    _buttonStates = List.filled(10, false);
    _notifyStream = _notify.orderBy('time_stamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Reminders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddNotify();
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/remainder-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StreamBuilder(
            stream: _notifyStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 29,
                      ),
                      Card(
                        color: Colors.white.withOpacity(0.4),
                        elevation: 4,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reason: ${document['reason']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "per each: ₹${document['each']}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Text(
                                    "Total: ₹${document['total']}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  Text(
                                    'Send to ${document['send-to']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${formattedTimestamp(document['time_stamp'].toDate())}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          // trailing: IconButton(
                          //   onPressed: () {
                          //     // Handle button press
                          //   },
                          //   icon: _buttonStates[index]
                          //       ? Icon(
                          //           Icons.done,
                          //           color: Colors.green,
                          //         )
                          //       : Icon(Icons.help),
                          // ),
                          leading: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(document['photoUrl']),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddNotify extends StatefulWidget {
  const AddNotify({Key? key}) : super(key: key);

  @override
  State<AddNotify> createState() => _AddNotifyState();
}

class _AddNotifyState extends State<AddNotify> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _notify =
      FirebaseFirestore.instance.collection('notify');

  TextEditingController _reasonController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _amountForEachController = TextEditingController();
  TextEditingController _sendAmountToController = TextEditingController();
  String selectedCommunity = "";
  List<String> communityOptions = [
    "Dani",
    "Jega",
    "Harish",
    "Deepak",
    "chandru",
    "praveen",
  ];
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

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
    print('Fetched user: ${_user?.displayName}');
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
                  controller: _reasonController,
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
                    hintText: "Reason for collecting money",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reason';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _totalAmountController,
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
                    hintText: "Total Amount",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _amountForEachController,
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
                    hintText: "Amount for Each One",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedCommunity,
                  hint: Text("Send Money to"), // Hint for the dropdown
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child:
                          Text("Send Money to"), // Displayed as the first item
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
                      // Extract values from the form fields
                      String reason = _reasonController.text;
                      String sendTo =
                          selectedCommunity; // Use the selected value from the dropdown
                      double total = double.parse(_totalAmountController.text);
                      double amountForEach =
                          double.parse(_amountForEachController.text);

                      // Add data to Firebase
                      try {
                        var now = DateTime.now();

                        // Get the Google username and user photo
                        String googleUserName = _user?.displayName ?? 'No Name';
                        String userPhotoUrl = _user!.photoURL!;

                        await _notify.add({
                          'reason': reason,
                          'send-to': sendTo,
                          'total': total,
                          'each': amountForEach,
                          'name': googleUserName,
                          'photoUrl': userPhotoUrl,
                          'time_stamp': now
                        });
                        print('Data added to Firebase');
                        setState(() {
                          selectedCommunity = "";
                        });

                        // Prepare notification content
                        String notiBody =
                            "₹" + amountForEach.toString() + " to " + sendTo;
                        String notiTitle = "Reminder to: " + reason;

                        // Send notifications to all users
                        await sendNotificationsToAllUsers(notiBody, notiTitle);

                        // Reset form fields after successful submission
                        _reasonController.clear();
                        _totalAmountController.clear();
                        _amountForEachController.clear();
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error adding data to Firebase: $e');
                        // Handle error
                      }
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
}
