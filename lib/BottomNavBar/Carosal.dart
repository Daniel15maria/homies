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
    return Column(
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
    );
  }

  List<Widget> _generateCarouselItems() {
    List<String> imageUrls = [
      'assets/homies11.jpeg',
      'assets/homies11.jpeg',
      'assets/homies11.jpeg',
      'assets/homies11.jpeg',
      'assets/homies11.jpeg',
      'assets/homies3.jpg',
      'assets/homies4.jpg',
      'assets/homies1.jpg',
      'assets/homies12.jpg',
      'assets/homies5.jpg',
      'assets/homies6.jpg',
      'assets/homies7.jpg',
      'assets/homies2.jpg',
      'assets/homies8.jpg',
      'assets/homies9.jpg',
      'assets/homies10.jpg',
      'assets/homies11.jpg',
>>>>>>> 92c2bb00a2ebef432216ff2fb81e665ad1600919
    ];

    return imageUrls
        .map(
          (imageUrl) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black, // Background color of the container
              borderRadius: BorderRadius.circular(25), // Border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover, // Set image fit to cover
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
