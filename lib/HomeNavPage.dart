import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/BottomNavBar/CleanPage.dart';
import 'package:homies/BottomNavBar/HomePage.dart';
import 'package:homies/BottomNavBar/PetrolPage.dart';
import 'package:homies/BottomNavBar/SpinPage.dart';
import 'package:homies/SideNavBar/SideNavBar.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});
  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  int _currentindex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CleanPage(),
    PetrolPage(),
    SpinWheel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Homies",
            style: GoogleFonts.oleoScriptSwashCaps(
              color: Colors.white,
            )),
        backgroundColor: Colors.black.withOpacity(0.2),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _widgetOptions[_currentindex], // Display the selected widget
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        unselectedItemColor: Colors.white, // Set the unselected icon color
        selectedItemColor: const Color.fromARGB(
            255, 171, 171, 171), // Set the selected icon color
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: "Cleaning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: "Petrol",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cached),
            label: "Spin",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
        currentIndex: _currentindex,
        selectedFontSize: 10,
        iconSize: 35,
      ),
    );
  }
}
