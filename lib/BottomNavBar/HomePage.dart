import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/homies-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "WELCOME HOMIES",
                    style: GoogleFonts.racingSansOne(
                      textStyle: TextStyle(
                        color: Color(0xFF50727B),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6.31,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/homies1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "~ The Boys ~",
                    style: GoogleFonts.racingSansOne(
                      textStyle: TextStyle(
                        color: Color(0xFF010108),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6.31,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Daniel",
                    description: '"One Life - One Love"',
                    incharge: "Hall",
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Harish",
                    description: '"Live Every Moment"',
                    incharge: "Room",
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Michael",
                    description: '"Love All, Serve All"',
                    incharge: "Kitchen",
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Steven",
                    description: '"Be Kind, Be True, Be You"',
                    incharge: "Garden",
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Andrew",
                    description: '"Dream Big, Work Hard"',
                    incharge: "Garage",
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    name: "Robert",
                    description: '"Stay Humble, Hustle Hard"',
                    incharge: "Hall",
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String name,
      required String description,
      required String incharge}) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Card(
        elevation: 4,
        color: Colors.white.withOpacity(0.8), // Set opacity for background
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xFFFFD9D9),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Incharge : $incharge',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
