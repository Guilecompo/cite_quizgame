import 'dart:async';

import 'package:cite_quizgame/scanner.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final List<String> imagePaths = [
  'images/1.png',
  'images/2.png',
  'images/3.png',
  'images/4.png',
  'images/5.png',
  'images/6.png',
  'images/7.png',
  'images/8.png',
  'images/9.png',
  'images/10.png',
  'images/11.png',
  'images/12.png',
];
final List<String> imageNamePaths = [
  'Python',
  'Java',
  'HTML',
  'JavaScript',
  'CSS',
  'Flutter',
  'Dart',
  'PHP',
  'MySQL',
  'C-Sharp',
  'Unity',
  'React',
];

late List<Widget> _pages;

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();
  late PageController _pageController;
  late Timer _timer;
  int _currentPageIndex = 0;
  final int _totalPages = imagePaths.length;

  Future<void> _saveName() async {
    final name = _nameController.text.trim();

    // Regular expression to validate only letters
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!nameRegExp.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name can only contain letters'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannerHome(name: name), // Pass the name here
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _totalPages *
            1000); // Set an arbitrary large value to start in the middle
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPageIndex = (_currentPageIndex + 1) % _totalPages;
        _pageController.animateToPage(
          _totalPages * 1000 +
              _currentPageIndex, // Use the large value plus current page index for smooth loop
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    _pages = List.generate(
      imagePaths.length,
      (index) => ImagePlaceholder(
        imagePath: imagePaths[index],
        imageName: imageNamePaths[index],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green[900],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/13.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Information Technology',
                        style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount:
                              null, // Set to null to allow infinite scrolling
                          itemBuilder: (context, index) {
                            // Calculate page index for smooth loop
                            int pageIndex = index % _totalPages;
                            return _pages[pageIndex];
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Celebrate IT Days with an exciting Quiz Game where the challenge is to find and scan QR codes! Test your coding knowledge by uncovering QR codes, which will reveal questions you need to answer. It is a fun and interactive way to sharpen your skills and embrace the thrill of competition!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your name',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;
  final String? imageName;
  const ImagePlaceholder({super.key, this.imagePath, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white12,
      height: 200,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            imagePath!,
            height: 100,
            width: double.infinity,
          ),
          const SizedBox(height: 10),
          Text(
            imageName ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
