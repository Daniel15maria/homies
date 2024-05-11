import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lottie/lottie.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  String rewards = "";
  bool showConfetti = false;

  List<Map<String, dynamic>> items = [
    {"name": "Dani", "image": "assets/dani.jpg"},
    {"name": "jega", "image": "assets/jega.jpg"},
    {"name": "chaandru", "image": "assets/chandru.jpg"},
    {"name": "deepak", "image": "assets/deepak.jpg"},
    {"name": "harish", "image": "assets/harish.png"},
    {"name": "rithvik", "image": "assets/rithvik.png"},
    {"name": "praveen", "image": "assets/praveen.png"}
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/spin-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spin And Choose",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0)
                            .withOpacity(0.8399999737739563),
                        fontSize: (MediaQuery.of(context).size.width) / 14,
                        fontFamily: 'Roboto Slab',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 1.81,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.add(Fortune.randomInt(0, items.length));
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 180,
                        color: const Color.fromARGB(255, 11, 11, 11),
                        child: Center(
                          child: Text(
                            "START",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: FortuneWheel(
                        selected: selected.stream,
                        animateFirst: false,
                        items: [
                          for (int i = 0;
                              i < items.length;
                              i++) ...<FortuneItem>{
                            FortuneItem(child: Text(items[i]["name"])),
                          },
                        ],
                        onAnimationEnd: () {
                          setState(() {
                            rewards = items[selected.value]["name"];
                            showConfetti = true;
                          });
                          print(rewards);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      items[selected.value]["image"],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      rewards.toString() + ", Your Turn to GO",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showConfetti = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showConfetti)
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: Lottie.asset(
                    'assets/confetti.json',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
