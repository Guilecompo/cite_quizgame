import 'dart:math';

import 'package:cite_quizgame/finalpage.dart';
import 'package:cite_quizgame/home.dart'; // Ensure this import is correct
import 'package:cite_quizgame/overlay.dart'; // Ensure this import is correct
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bgColor = Color(0xFF1b5e20);

final List<Map<String, String>> questionsAndAnswers = [
  {
    "question": "What does the acronym 'OS' stand for in computing?",
    "answer": "operating system"
  },
  {
    "question": "What does 'URL' stand for?",
    "answer": "uniform resource locator"
  },
  {
    "question": "What does 'SSD' stand for in computer storage?",
    "answer": "solid state drive"
  },
  {
    "question": "What does 'GUI' stand for?",
    "answer": "graphical user interface"
  },
  {"question": "What does 'LAN' stand for?", "answer": "local area network"},
  {
    "question": "Who is considered as the Father of Computers?",
    "answer": "charles babbage"
  },
  {
    "question": "Who is Bill Gates’ co-founder at Microsoft?",
    "answer": "paul allen"
  },
  {
    "question": "Who is Steve Jobs' co-founder at Apple?",
    "answer": "steve wozniak"
  },
  {
    "question": "What company invented the programming language Java?",
    "answer": "sun microsystems"
  },
  {
    "question": "CPU is the brain of the computer. What does CPU stand for?",
    "answer": "central processing unit"
  },
  {
    "question":
        "What is the primary input device used for typing text into a computer?",
    "answer": "keyboard"
  },
  {
    "question":
        "What is the primary input device used to point, click, and interact with items on a computer screen?",
    "answer": "mouse"
  },
  {
    "question": "What is the name of Apple’s popular smartphone?",
    "answer": "iphone"
  },
  {
    "question":
        "It is a mobile operating system developed by Google. What is it called?",
    "answer": "android"
  },
  {
    "question":
        "What is the name of the operating system developed by Microsoft?",
    "answer": "windows"
  },
  {
    "question": "What is the name of the first computer programmer?",
    "answer": "ada lovelace"
  },
  {
    "question":
        "What is the name of the most popular streaming service that offers movies, TV shows, and original content?",
    "answer": "netflix"
  },
  {
    "question":
        "What is the name of the popular music streaming service that offers a vast library of songs, podcasts, and playlists, and is owned by Apple?",
    "answer": "apple music"
  },
  {
    "question":
        "What is the name of the social media platform founded by Mark Zuckerberg in 2004?",
    "answer": "facebook"
  },
  {
    "question":
        "What is the name of the popular social media platform known for short-form videos and viral challenges?",
    "answer": "tiktok"
  },
  {
    "question":
        "What is the network security device that monitors and controls incoming and outgoing network traffic based on predetermined security rules?",
    "answer": "firewall"
  },
  {
    "question":
        "What is the term for someone who uses their technical skills to gain unauthorized access to computer systems?",
    "answer": "hacker"
  },
  {
    "question": "What is the command used to display output in Python?",
    "answer": "print"
  },
  {
    "question":
        "What is the term for a storage location in programming that can hold different values during the execution of a program?",
    "answer": "variable"
  },
  {
    "question": "What is the meaning of this condition `!=` in programming ?",
    "answer": "not equal"
  },
  {
    "question": "What is the meaning of this condition `<` in programming ?",
    "answer": "less than"
  },
  {
    "question": "What is the meaning of this condition `>` in programming ?",
    "answer": "greater than"
  },
  {"question": "What is the result of `print(5 + 3)` ?", "answer": "8"},
  {"question": "What is the result of `print(5 * 3)` ?", "answer": "15"},
  {"question": "What is the result of `print(15 - 3)` ?", "answer": "12"},
];

final List<String> qrCodeOrder = [
  'PHINMA_COC_CITE_Question1',
  'PHINMA_COC_CITE_Question2',
  'PHINMA_COC_CITE_Question3',
  'PHINMA_COC_CITE_Question4',
  'PHINMA_COC_CITE_Question5',
  'PHINMA_COC_CITE_Question6',
  'PHINMA_COC_CITE_Question7',
  'PHINMA_COC_CITE_Question8',
  'PHINMA_COC_CITE_Question9',
  'PHINMA_COC_CITE_Question10',
];

final List<String> hints = [
  'Hint: Start here',
  'Hint: Look for something blue',
  'Hint: Find Governor Name',
  'Hint: Look for 6 side shape',
  'Hint: Look for the logo of Javascript',
  'Hint: Look for the output of print(13 + 12)',
  'Hint: Find Dean Name',
  'Hint: Find the name of Network Security instructor',
  'Hint: Find for the logo of Python',
  'Hint: Find the name of SBO adviser',
];

class ScannerHome extends StatefulWidget {
  final String name;
  const ScannerHome({Key? key, required this.name}) : super(key: key);

  @override
  _ScannerHomeState createState() => _ScannerHomeState();
}

class _ScannerHomeState extends State<ScannerHome> {
  bool _isCooldownActive = false;
  bool _isScanning = true;
  bool _isFinalScoreDialogActive = false; // Add this flag
  Set<String> _scannedCodes = {};
  List<Map<String, String>> _remainingQuestions =
      List.from(questionsAndAnswers);
  int _nextExpectedIndex = 0;
  int _score = 0;
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? name;
  int? number;
  int? score;

  @override
  void initState() {
    super.initState();
    _checkCriteria();
  }

  Future<void> _checkCriteria() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    number = prefs.getInt('number');
    score = prefs.getInt('score');

    if (name != null && number != null && score != null && score! >= 6) {
      // Navigate to final page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Finalpage(),
        ),
      );
    } else {
      // Stay on the current page
      setState(() {});
    }
  }

  @override
  Future<bool> onWillPop() async {
    // Prevent back navigation by returning false
    return Future.value(false);
  }

  void _pauseScanning() {
    setState(() {
      _isScanning = false;
    });
  }

  void _resumeScanning() {
    setState(() {
      _isScanning = true;
    });
  }

  void _showQuestionDialog(
      String question, String correctAnswer, int currentIndex) {
    _pauseScanning();
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Question ${currentIndex + 1} out of ${qrCodeOrder.length}',
            style: TextStyle(fontSize: 22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                question,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                controller: _answerController,
                padding: EdgeInsets.all(16.0),
                placeholder: 'Your Answer',
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoButton(
              borderRadius: BorderRadius.zero,
              color: Colors.blue[800],
              onPressed: () {
                String userAnswer = _answerController.text.trim().toLowerCase();
                String correctAnswerLower = correctAnswer.toLowerCase();
                if (userAnswer == correctAnswerLower) {
                  setState(() {
                    _score++;
                  });
                }
                Navigator.of(context).pop(); // Close the question dialog
                _answerController.clear(); // Clear the text field

                // Show submission confirmation dialog
                _showSubmissionConfirmationDialog();

                if (_scannedCodes.length == qrCodeOrder.length) {
                  _showFinalScoreDialog();
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((_) =>
        _resumeScanning()); // Ensure scanning resumes when the dialog is dismissed
  }

  void _showSubmissionConfirmationDialog() {
    _pauseScanning(); // Ensure scanning is paused
    setState(() {
      _isFinalScoreDialogActive = true; // Set flag to true
    });
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Submission Confirmation'),
          content: Text('Your answer is submitted.\n\n${_getNextHint()}'),
          actions: <Widget>[
            CupertinoButton(
              color: Colors.blue[800],
              borderRadius: BorderRadius.zero,
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                setState(() {
                  _isFinalScoreDialogActive = false; // Reset flag
                });
                _resumeScanning();
              },
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isFinalScoreDialogActive = false; // Reset flag
      });
      _resumeScanning(); // Resume scanning after the dialog is dismissed
    });
  }

  String _getNextHint() {
    if (_nextExpectedIndex < hints.length) {
      return 'Hint for the next QR Code: ${hints[_nextExpectedIndex]}';
    }
    return '';
  }

  void _startCooldown() {
    setState(() {
      _isCooldownActive = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isCooldownActive = false;
      });
    });
  }

  void _handleScan(String code) {
    if (_isFinalScoreDialogActive) {
      // If final score dialog is active, do not process scans
      return;
    }

    if (!_isCooldownActive && _isScanning) {
      _startCooldown();

      if (_isValidCode(code)) {
        int index = qrCodeOrder.indexOf(code);

        if (index == -1) {
          _showScanResultDialog('QR code not found');
          return;
        }

        if (index != _nextExpectedIndex) {
          _showScanResultDialog('Find the other QR');
          return;
        }

        if (_scannedCodes.contains(code)) {
          _showScanResultDialog('Find the next QR');
        } else {
          _scannedCodes.add(code);

          if (_remainingQuestions.isNotEmpty) {
            int questionIndex = _random.nextInt(_remainingQuestions.length);
            Map<String, String> questionData =
                _remainingQuestions[questionIndex];

            _showQuestionDialog(questionData['question']!,
                questionData['answer']!, _nextExpectedIndex);

            setState(() {
              _remainingQuestions.removeAt(questionIndex);
            });
          } else {
            _showScanResultDialog('No more questions available');
          }

          setState(() {
            _nextExpectedIndex++;
          });
        }
      } else {
        _showScanResultDialog('QR code not found');
      }
    }
  }

  bool _isValidCode(String code) {
    return qrCodeOrder.contains(code);
  }

  void _showScanResultDialog(String message) {
    _pauseScanning();
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Scan Result'),
          content: Text(message),
          actions: <Widget>[
            CupertinoButton(
              color: Colors.blue[800],
              borderRadius: BorderRadius.zero,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resumeScanning(); // Resume scanning after the dialog is closed
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then(
      (_) => _resumeScanning(),
    ); // Ensure scanning resumes when the dialog is dismissed
  }

  void _showFinalScoreDialog() {
    _pauseScanning(); // Ensure scanning is paused
    setState(() {
      _isFinalScoreDialogActive = true; // Set flag to true
    });

    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Final Score'),
          content: _score < 6
              ? Text('Your final score is: $_score')
              : Text(
                  'Congratulations! Your final score is: $_score\n\nClaim your prize by proceeding to the admin. Thank you for playing.\n\n Do not close it so the admin verify that you win.',
                  style: TextStyle(fontSize: 16),
                ),
          actions: <Widget>[
            if (_score < 6) ...[
              CupertinoButton(
                color: Colors.blue[800],
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _scannedCodes.clear();
                    _remainingQuestions = List.from(questionsAndAnswers);
                    _nextExpectedIndex = 0;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {
                    _isFinalScoreDialogActive = false; // Reset flag
                  });
                  _resumeScanning(); // Resume scanning after the dialog is closed
                },
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CupertinoButton(
                color: Colors.red[800],
                borderRadius: BorderRadius.zero,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString(
                      'score', _score.toString()); // Store score as string
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(), // Pass the score
                    ),
                  );
                  setState(() {
                    _isFinalScoreDialogActive = false; // Reset flag
                  });
                  _resumeScanning(); // Resume scanning after the dialog is closed
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ] else ...[
              CupertinoTextField(
                controller: _passwordController,
                obscureText: true,
                padding: EdgeInsets.all(16.0),
                placeholder: 'Enter Password',
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              CupertinoButton(
                color: Colors.blue[800],
                borderRadius: BorderRadius.zero,
                onPressed: () async {
                  if (_passwordController.text == 'CITE2024') {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString(
                        'score', _score.toString()); // Store score as string
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Finalpage(), // Pass the score
                      ),
                    );
                    setState(() {
                      _isFinalScoreDialogActive = false; // Reset flag
                    });
                    _resumeScanning(); // Resume scanning after the dialog is closed
                  } else {
                    _showScanResultDialog(
                        'Incorrect password. You cannot close the game.');
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isFinalScoreDialogActive = false; // Reset flag
      });
      _resumeScanning(); // Resume scanning after the dialog is dismissed
    });
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
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  Expanded(
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hello, ${widget.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Place the QR code',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        if (_isScanning)
                          MobileScanner(
                            onDetect: (barcode) {
                              String code =
                                  barcode.barcodes.first.displayValue ?? '---';
                              _handleScan(code);
                            },
                          ),
                        QRScannerOverlay(overLayColor: bgColor),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'CITE Developer',
                        style: TextStyle(
                          color: Colors.yellow[600],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
