import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/BottomNavBar/CleanPage.dart';
import 'package:homies/BottomNavBar/HomePage.dart';
import 'package:homies/BottomNavBar/PetrolPage.dart';
import 'package:homies/BottomNavBar/SpinPage.dart';
import 'package:homies/SideNavBar/SideNavBar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({Key? key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  int _currentPage = 0;
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
        title: Text(
          "Homies",
          style: GoogleFonts.oleoScriptSwashCaps(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _widgetOptions[_currentPage], // Display the selected widget
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        items: <TabItem>[
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.cleaning_services_sharp, title: 'Clean'),
          TabItem(icon: Icons.local_gas_station, title: 'Petrol'),
          TabItem(icon: Icons.rocket_rounded, title: 'Spin'),
        ],
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        initialActiveIndex: _currentPage,
        style: TabStyle.reactCircle,
        height: 60,
      ),
    );
  }
}
