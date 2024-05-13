// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetrolPage extends StatefulWidget {
  const PetrolPage({Key? key});

  @override
  State<PetrolPage> createState() => _PetrolPageState();
}

class _PetrolPageState extends State<PetrolPage> {
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  late String fromUser = ''; // Declare fromUser variable

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
              height: 30,
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
                      return PetrolDetails(
                        // Pass the function to update fromUser to PetrolDetails
                        updateFromUser: (String value) {
                          setState(() {
                            fromUser = value;
                          });
                        },
                      );
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
<<<<<<< HEAD

=======
                    var documents = snapshot.data!.docs;
>>>>>>> 4b0044aa4d612258d35485859c04072db6beea27
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
<<<<<<< HEAD
                        var data = snapshot.data?.docs[index].data();
=======
                        var data =
                            documents[index].data() as Map<String, dynamic>;
>>>>>>> 4b0044aa4d612258d35485859c04072db6beea27
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
                                  title: Text(data?['name'] ?? ''),
                                  subtitle: Text(
                                      data?['time_stamp']?.toString() ?? ''),
                                  trailing: Text('₹ ${data?['amount'] ?? ''}'),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
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
  final Function(String) updateFromUser; // Define function to update fromUser

  const PetrolDetails({required this.updateFromUser, Key? key});

  @override
  State<PetrolDetails> createState() => _PetrolDetailsState();
}

class _PetrolDetailsState extends State<PetrolDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
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
                  {
                    // Update fromUser with the entered value
                    widget.updateFromUser(_titleController.text);
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
