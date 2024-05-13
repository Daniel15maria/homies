// ignore_for_file: prefer_const_constructors, use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/HomeNavPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Users {
  final String displayName;
  final String email;

  Users({
    required this.displayName,
    required this.email,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background photo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login-bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Login button with Google
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 240),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text('Homies',
                      style: GoogleFonts.oleoScriptSwashCaps(
                          textStyle: TextStyle(
                        color: Color.fromARGB(255, 254, 254, 255),
                        fontSize: 57.35,
                        fontFamily: 'Oleo Script Swash Caps',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 6.31,
                      ))),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      fixedSize:
                          Size((MediaQuery.of(context).size.width) - 100, 45),
                    ),
                    onPressed: () async {
                      print(MediaQuery.of(context).size.width);
                      await signInWithGoogle();
                      // Navigator.of(context, rootNavigator: true).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeNavPage()),
                      );
                    },
                    icon: Image.asset(
                      'assets/g.png',
                      height: 24.0, // Adjust the height as needed
                    ),
                    label: Text(' Login with Google'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Users> signInWithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
  UserCredential userCred =
      await FirebaseAuth.instance.signInWithCredential(credential);
  print(userCred.user?.displayName);
  String displayName = userCred.user?.displayName ?? "";
  String email = userCred.user?.email ?? "";

  // Create a User object
  Users users = Users(
    displayName: displayName,
    email: email,
  );
  return users;
}
