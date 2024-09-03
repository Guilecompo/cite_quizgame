import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  Future<void> _launchURL1() async {
    final Uri url1 = Uri.parse(
        'https://guileportfolio.netlify.app/'); // Replace with your first URL
    if (await canLaunchUrl(url1)) {
      await launchUrl(url1);
    } else {
      throw 'Could not launch $url1';
    }
  }

  Future<void> _launchURL2() async {
    final Uri url2 = Uri.parse(
        'https://www.second-example.com'); // Replace with your second URL
    if (await canLaunchUrl(url2)) {
      await launchUrl(url2);
    } else {
      throw 'Could not launch $url2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: 320,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('images/g.jpg'),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Kide Guile Compo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Bachelor of Science in Information Technology',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'System Developer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: _launchURL1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.yellow[700],
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Visit Portfolio',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: 320,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('images/s.jpg'),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Shadrin Jerome Mopal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Bachelor of Science in Information Technology',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'System Developer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: _launchURL1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.yellow[700],
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Visit Portfolio',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
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
    );
  }
}
