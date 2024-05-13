import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);

  return '$formattedTime \n$formattedDate';
}

class PetrolPage extends StatefulWidget {
  const PetrolPage({Key? key});

  @override
  State<PetrolPage> createState() => _PetrolPageState();
}

class _PetrolPageState extends State<PetrolPage> {
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 100,
            ),
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
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream: _petrol.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.6),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  title: Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    '${formattedTimestamp(data['time_stamp'].toDate())}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    '₹ ${data['amount']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        color: Colors.black),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetrolDetails extends StatefulWidget {
  const PetrolDetails({Key? key});

  @override
  State<PetrolDetails> createState() => _PetrolDetailsState();
}

class _PetrolDetailsState extends State<PetrolDetails> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  TextEditingController _titleController = TextEditingController();
  late User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    int amount = int.tryParse(value) ?? 0;
    if (amount <= 25) {
      return 'Fill petrol more than ₹25';
    }
    return null;
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  hintText: "Enter Amount",
                  alignLabelWithHint: true,
                ),
                validator: _validateAmount,
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
                    // Get the current timestamp
                    var now = DateTime.now();

                    // Get the Google username and user photo
                    String googleUserName = _user?.displayName ?? 'No Name';
                    String userPhotoUrl = _user!.photoURL!;

                    // Send the data to Firestore
                    await _petrol.add({
                      'amount': int.parse(_titleController.text),
                      'time_stamp': now,
                      'name': googleUserName,
                      'photoUrl': userPhotoUrl,
                    });

                    // Close the dialog
                    Navigator.pop(context);
                  }
                },
                child: Text('SEND'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
