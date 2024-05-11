import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/BottomNavBar/Carosal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget _buildCard({
      required String name,
      required String description,
      required String incharge,
      required BuildContext context,
      required String? imagePath,
    }) {
      TextStyle _nameTextStyle(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double scaleFactor = screenWidth > 600 ? 1.5 : 1.0;
        double fontSize = 20.0 * scaleFactor;
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        );
      }

      TextStyle _descriptionTextStyle(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double scaleFactor = screenWidth > 600 ? 1.5 : 1.0;
        double fontSize = 15.0 * scaleFactor;
        return TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        );
      }

      TextStyle _inchargeTextStyle(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double scaleFactor = screenWidth > 600 ? 1.5 : 1.0;
        double fontSize = 20.0 * scaleFactor;
        return TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        );
      }

      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Card(
          elevation: 4,
          color: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (imagePath != null)
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFFFFD9D9),
                      backgroundImage: AssetImage(imagePath),
                    ),
                  if (imagePath == null)
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
                        style: _nameTextStyle(context),
                      ),
                      SizedBox(height: 7),
                      Text(
                        description,
                        style: _descriptionTextStyle(context),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Incharge : $incharge',
                        style: _inchargeTextStyle(context),
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

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.png', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Container(
            color: Colors.transparent, // Transparent background
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Card(
                        color: Colors.white.withOpacity(0.5),
                        child: Text(
                          " WELCOME HOMIES! ",
                          style: GoogleFonts.racingSansOne(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 84, 18, 18),
                              fontSize: MediaQuery.of(context).size.width / 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 6.31,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CarouselCommunities(),

                      SizedBox(height: 20),
                      Card(
                        elevation: 0,
                        color: Colors.white.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            " ~ The Boys ~ ",
                            style: GoogleFonts.racingSansOne(
                              textStyle: TextStyle(
                                color: Color(0xFF010108),
                                fontSize:
                                    MediaQuery.of(context).size.width / 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 6.31,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // These are the six cards with individual photos
                      _buildCard(
                        name: "Daniel",
                        description: '"Love For Life"',
                        incharge: "Hall",
                        context: context,
                        imagePath: 'assets/dani.jpg',
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        name: "Harish",
                        description: '"Amaai Official"',
                        incharge: "BedRoom",
                        context: context,
                        imagePath: 'assets/harish.png',
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        name: "Chandru",
                        description: "Chain Smoker",
                        incharge: "Kitchen",
                        context: context,
                        imagePath: 'assets/chandru.jpg',
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        name: "Jaga",
                        description: '"5 rupa"',
                        incharge: "Restroom",
                        context: context,
                        imagePath: 'assets/jega.jpg',
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        name: "Deepak",
                        description: '"Botha kai"',
                        incharge: "NILL",
                        context: context,
                        imagePath: 'assets/deepak.png',
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        name: "Praveen",
                        description: '"NIGGA karupu"',
                        incharge: "Absent",
                        context: context,
                        imagePath: 'assets/praveen.png',
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
