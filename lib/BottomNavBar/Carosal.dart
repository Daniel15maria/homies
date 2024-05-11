import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselCommunities extends StatefulWidget {
  @override
  _CarouselCommunitiesState createState() => _CarouselCommunitiesState();
}

class _CarouselCommunitiesState extends State<CarouselCommunities> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set width to match parent widget
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: _generateCarouselItems(), // Generating sample carousel items
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3), // Duration for each slide
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9, // Set aspect ratio as needed
              initialPage: 2,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateCarouselItems() {
    List<String> imageUrls = [
      'assets/homies1.png',
      'assets/homies1.png',
      'assets/homies1.png',
      'assets/homies1.png',
      'assets/homies1.png',
    ];

    return imageUrls
        .map(
          (imageUrl) => Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 15, 15, 15), // Background color of the container
              borderRadius: BorderRadius.circular(25), // Border radius
            ),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover, // Set image fit to cover
            ),
          ),
        )
        .toList();
  }
}
