import 'dart:math';

import 'package:cite_quizgame/home.dart'; // Ensure this import is correct
import 'package:cite_quizgame/overlay.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const bgColor = Color(0xFF1b5e20);

final List<Map<String, String>> questionsAndAnswers = [
  {"question": "What is 1 + 1?", "answer": "2"},
  {"question": "What is 5 - 3?", "answer": "2"},
  {"question": "What is 4 × 7?", "answer": "28"},
  {"question": "What is 9 ÷ 3?", "answer": "3"},
  {"question": "What is 8 + 6?", "answer": "14"},
  {"question": "What is 15 - 7?", "answer": "8"},
  {"question": "What is 3 × 6?", "answer": "18"},
  {"question": "What is 12 ÷ 4?", "answer": "3"},
  {"question": "What is 7 + 9?", "answer": "16"},
  {"question": "What is 18 - 5?", "answer": "13"},
  {"question": "What is 5 × 5?", "answer": "25"},
  {"question": "What is 20 ÷ 2?", "answer": "10"},
  {"question": "What is 6 + 11?", "answer": "17"},
  {"question": "What is 14 - 8?", "answer": "6"},
  {"question": "What is 7 × 3?", "answer": "21"},
  {"question": "What is 24 ÷ 6?", "answer": "4"},
  {"question": "What is 13 + 7?", "answer": "20"},
  {"question": "What is 30 - 10?", "answer": "20"},
  {"question": "What is 9 × 2?", "answer": "18"},
  {"question": "What is 45 ÷ 9?", "answer": "5"},
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

class ScannerHome extends StatefulWidget {
  final String name;
  const ScannerHome({Key? key, required this.name}) : super(key: key);

  @override
  _ScannerHomeState createState() => _ScannerHomeState();
}

class _ScannerHomeState extends State<ScannerHome> {
  bool _isCooldownActive = false;
  Set<String> _scannedCodes = {};
  List<Map<String, String>> _remainingQuestions =
      List.from(questionsAndAnswers);
  int _nextExpectedIndex = 0;
  int _score = 0;
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  bool _isAdminMode = false;

  void _showQuestionDialog(
      String question, String correctAnswer, int currentIndex) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Question ${currentIndex + 1} out of ${qrCodeOrder.length}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question),
              SizedBox(height: 10),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Answer',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String userAnswer = _answerController.text.trim();
                if (userAnswer == correctAnswer) {
                  setState(() {
                    _score++;
                  });
                }
                Navigator.of(context).pop(); // Close the dialog
                _answerController.clear(); // Clear the text field

                if (_scannedCodes.length == qrCodeOrder.length) {
                  _showFinalScoreDialog();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
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
    if (!_isCooldownActive) {
      _startCooldown();

      if (_isValidCode(code)) {
        int index = qrCodeOrder.indexOf(code);

        if (index == -1) {
          _showScanResultDialog('QR code not found');
          return;
        }

        if (index != _nextExpectedIndex) {
          _showScanResultDialog('Not yet find the other QR');
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
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalScoreDialog() {
    final TextEditingController _passwordController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Final Score'),
          content: _score < 6
              ? Text('Your final score is: $_score')
              : Text(
                  'Congratulations! Your final score is: $_score\n\nClaim your prize by proceeding to the admin. Thank you for playing.\n\n Do not close it so the admin verify that you win.'),
          actions: [
            if (_score < 6) ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _scannedCodes.clear();
                    _remainingQuestions = List.from(questionsAndAnswers);
                    _nextExpectedIndex = 0;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Try Again'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Home()), // Navigate to home screen
                  );
                },
                child: const Text('Logout'),
              ),
            ] else ...[
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                ),
                obscureText: true,
              ),
              TextButton(
                onPressed: () {
                  if (_passwordController.text == '12345') {
                    // Replace with actual password
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    _showScanResultDialog(
                        'Incorrect password. You cannot close the game.');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Information Technology',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontSize: 20,
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
                        color: Colors.white70,
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
    );
  }
}
