import 'package:flutter/material.dart';

class PetrolPage extends StatefulWidget {
  const PetrolPage({Key? key});

  @override
  State<PetrolPage> createState() => _PetrolPageState();
}

class _PetrolPageState extends State<PetrolPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text widget
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Petrol Boys',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Button widget
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
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
                  return PetrolDetails();
                },
              );
              // Add your button functionality here
            },
            child: Text('Enter Details'),
          ),
        ),
        // List of PetrolPage widgets
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Number of PetrolPage widgets
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Daniel'),
                subtitle: Text('Feb 19, 05:45 AM'),
                trailing: Text('₹ 150'),
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  // backgroundImage: AssetImage('images/u1.png'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PetrolDetails extends StatefulWidget {
  const PetrolDetails({super.key});

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
                    'Send Notification',
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
                    hintText: "Enter Notification Title",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
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
}
