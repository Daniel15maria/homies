// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/HomeNavPage.dart';

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
                image: AssetImage('assets/login-bg.png'),
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
                  Text('Homies',
                      style: GoogleFonts.oleoScriptSwashCaps(
                          textStyle: TextStyle(
                        color: Color(0xFF010108),
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
                    onPressed: () {
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
