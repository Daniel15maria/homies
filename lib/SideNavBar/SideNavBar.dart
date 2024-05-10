import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            padding: EdgeInsets.all(20),
            color: Color(0xFF002D56),
            child: Center(
              child: Text(
                "Name",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Photos"),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MapPage()),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Reminders'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Log Out"),
            onTap: () async {
              // await GoogleSignIn().signOut();
              // FirebaseAuth.instance.signOut();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
            },
          )
        ],
      ),
    );
  }
}
