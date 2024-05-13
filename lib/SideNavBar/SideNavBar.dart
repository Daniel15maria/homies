import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homies/LoginPage.dart';
import 'package:homies/SideNavBar/Notifify.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 6, 6, 6),
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _user!.photoURL != null
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width *
                              0.1, // Adjust the percentage as needed
                          backgroundImage: NetworkImage(_user!.photoURL!),
                        )
                      : CircleAvatar(
                          radius: MediaQuery.of(context).size.width *
                              0.1, // Adjust the percentage as needed
                          backgroundColor: Colors
                              .blue, // You can set your desired background color
                          child: Text(
                            _user!.displayName![0],
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.1, // Adjust the percentage as needed
                              color: Colors.white,
                            ),
                          ),
                        ),
                  SizedBox(
                      height: MediaQuery.of(context).size.width *
                          0.02), // Adjust the percentage as needed
                  Text(
                    "${_user?.displayName ?? 'No Name'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width *
                          0.05, // Adjust the percentage as needed
                    ),
                  ),
                ],
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
              print(MediaQuery.of(context).size.width);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifyPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Log Out"),
            onTap: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
