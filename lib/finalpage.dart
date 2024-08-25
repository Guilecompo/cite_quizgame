import 'dart:async';

import "package:flutter/material.dart";

const bgColor = Color(0xFF1b5e20);

class Finalpage extends StatefulWidget {
  const Finalpage({Key? key}) : super(key: key);

  @override
  _FinalpageState createState() => _FinalpageState();
}

final List<String> imagePaths = [
  'images/1.png',
  'images/2.png',
];

late List<Widget> _pages;

class _FinalpageState extends State<Finalpage> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPageIndex = 0;
  final int _totalPages = imagePaths.length;

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
      backgroundColor: bgColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/13.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              5.0,
            ),
            child: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Information Technology',
                        style: TextStyle(
                          color: Colors.yellow[600],
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        color: Colors.white54,
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
                        height: 35,
                      ),
                      Container(
                        color: Colors.white12,
                        padding: const EdgeInsets.all(6),
                        child: const Text(
                          '\t\t\tCelebrate IT Days with an exciting Quiz Game where the challenge is to find and scan QR codes! \n\n\t\t\tTest your coding knowledge by uncovering QR codes, which will reveal questions you need to answer. \n\n\t\t\tIt is a fun and interactive way to sharpen your skills and embrace the thrill of competition!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        color: Colors.orange,
                        padding: const EdgeInsets.all(6),
                        child: const Text(
                          '\t\t\You already passed the quiz, you can’t play again.',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
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
