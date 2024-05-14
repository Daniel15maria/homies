import 'package:flutter/material.dart';

class Photos extends StatefulWidget {
  const Photos({Key? key}) : super(key: key);

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: folderNames.length, // Number of folders
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetails(
                    folderIndex: index,
                    folderName: folderNames[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      folderBackgrounds[index]), // Use folder background
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// List of folder names
List<String> folderNames = [
  'Deepak',
  'Chandru',
  'Jega-lab',
  'Harish',
  'Praveen',
  'Dani',
  'Rithvik',
];
List<String> folderBackgrounds = [
  'assets/deepak.png',
  'assets/chandru.jpg',
  'assets/jega.jpg',
  'assets/harish.png',
  'assets/praveen.png',
  'assets/dani.jpg',
  'assets/rithvik.png',
];

class FolderDetails extends StatelessWidget {
  final int folderIndex;
  final String folderName;

  const FolderDetails({
    Key? key,
    required this.folderIndex,
    required this.folderName,
  }) : super(key: key);

  // Define image locations for each folder
  static List<List<String>> folderImages = [
    // Folder 1 images
    [
      'assets/deepak.png',
      'assets/deepak.png',
      'assets/deepak.png',
      'assets/deepak.png',
    ],
    // Folder 2 images
    [
      'assets/chandru.jpg',
      'assets/chandru.jpg',
    ],
    // Folder 3 images
    [
      'assets/jega.jpg',
      'assets/jega.jpg',
      'assets/jega.jpg',
      'assets/jega.jpg',
    ],
    // Folder 4 images
    [
      'assets/harish.png',
      'assets/harish.png',
      'assets/harish.png',
      'assets/harish.png',
    ],
    // Folder 5 images
    [
      'assets/praveen.png',
      'assets/praveen.png',
      'assets/praveen.png',
    ],
    // Folder 6 images
    [
      'assets/dani.jpg',
      'assets/dani.jpg',
      'assets/dani.jpg',
      'assets/dani.jpg',
    ],
    // Folder 7 images
    [
      'assets/rithvik.png',
      'assets/rithvik.png',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: folderImages[folderIndex].length,
        itemBuilder: (context, index) {
          return Image.asset(
            folderImages[folderIndex]
                [index], // Use individual photos inside the folder
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
