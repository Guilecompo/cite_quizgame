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

  String? _no;
  String? _name;
  String? _score;
  bool _isInputEnabled = true; // Track if input should be enabled

  @override
  void initState() {
    super.initState();
    _checkAndClearLocalStorage(); // Check and clear local storage if needed
    _loadNo();
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

  Future<void> _checkAndClearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lastVisitTimestamp = prefs.getInt('last_visit_timestamp');
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if 1 minute (60000 milliseconds) has passed
    if (lastVisitTimestamp != null &&
        (currentTime - lastVisitTimestamp) > 60 * 1000) {
      // Clear all data from SharedPreferences
      await prefs.clear();

      // Refresh the page after clearing data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      // Update the timestamp to the current time
      await prefs.setInt('last_visit_timestamp', currentTime);
    }
  }

  Future<void> _loadNo() async {
    // Retrieve stored values
    final no = await getStoredNo();
    final name = await getStoredName();
    final scoreString = await getStoredScore();

    // Convert scoreString to an integer if it's not null
    final score = int.tryParse(scoreString ?? '') ?? 0;

    // Debug print statements
    print('Stored No: $no');
    print('Stored Name: $name');
    print('Stored Score: $score');

    // Update state with the retrieved values
    setState(() {
      _no = no;
      _name = name;
      _score = scoreString; // Storing as a string, if needed elsewhere

      // Determine if the input should be enabled
      _isInputEnabled =
          !(no == '1' && name != null && name.isNotEmpty && score >= 6);

      print('Is Input Enabled: $_isInputEnabled');

      // Check conditions and navigate or show error
      if (_no == '1') {
        if (_name!.isNotEmpty) {
          if (score < 6) {
            // Navigate to ScannerHome if the score is less than 6
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScannerHome(name: _name!),
              ),
            );
          } else {
            // Show SnackBar if the score is greater than or equal to 6
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'You already passed the quiz, you can’t play again.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.orange,
                duration: Duration(minutes: 5),
              ),
            );
          }
        }
      }
    });
  }

  Future<String?> getStoredNo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? no =
        prefs.getString('no'); // Replace 'no' with your actual key
    return no;
  }

  Future<String?> getStoredName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? name =
        prefs.getString('name'); // Replace 'name' with your actual key
    return name;
  }

  Future<String?> getStoredScore() async {
    final prefs = await SharedPreferences.getInstance();
    final String? score =
        prefs.getString('score'); // Replace 'score' with your actual key
    return score;
  }

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
      await prefs.setString('no', '1');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannerHome(name: name), // Pass the name here
        ),
      );
    }
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
                        enabled:
                            _isInputEnabled, // Enable or disable TextField based on condition
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isInputEnabled
                              ? _saveName
                              : null, // Enable or disable button based on condition
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
