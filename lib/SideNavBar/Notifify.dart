import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  List<bool> _buttonStates = [];

  void initState() {
    super.initState();
    _buttonStates =
        List.filled(10, false); // Initialize with false values for 10 items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Remainders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFD9D9),
        foregroundColor: Color(0xFF002D56),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add your action here
              print('Add button pressed');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Number of items in the list
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text('Daniel'),
              subtitle: Column(
                children: [
                  Text('Send to Harrish'),
                  Text("per each=250"),
                  Text("Total=1000"),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _buttonStates[index] = !_buttonStates[index];
                  });
                },
                icon:
                    _buttonStates[index] ? Icon(Icons.done) : Icon(Icons.help),
              ),
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/u1.png'),
              ),
            ),
          );
        },
      ),
    );
  }
}
