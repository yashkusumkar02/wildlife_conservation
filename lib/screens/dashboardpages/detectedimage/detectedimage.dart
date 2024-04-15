import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wildsense/screens/dashboardpages/homescreen/homescreen.dart';
import '../../../pages/customnavbar.dart';
import '../../../widget/graph/line2chart.dart';
import '../../../widget/indicator/carousel_indicator_species.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class DetectorHome extends StatefulWidget {
  final String detectedLabel;

  const DetectorHome({Key? key, required this.detectedLabel}) : super(key: key);

  @override
  State<DetectorHome> createState() => _DetectorHomeState();
}

class _DetectorHomeState extends State<DetectorHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _labelInfo = ''; // Variable to store label information
  bool _isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Fetch label information
    fetchLabelInfo(widget.detectedLabel).then((info) {
      setState(() {
        _labelInfo = info;
        _isLoading = false; // Set loading state to false when data is fetched
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Set loading state to false if there's an error
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> fetchLabelInfo(String label) async {
    try {
      final response = await http.get(
        Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$label'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String extract = data['extract'] ?? '';
        // Limiting to 4-5 lines
        if (extract.length > 500) {
          extract = extract.substring(0, 500) + '...';
        }
        return extract;
      } else {
        throw Exception('Failed to load label information');
      }
    } catch (e) {
      print('Error fetching label information: $e');
      return 'Failed to load label information. Please try again later.';
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _isLoading = true; // Set loading state to true while fetching data
    });

    // Fetch label information
    await fetchLabelInfo(widget.detectedLabel).then((info) {
      setState(() {
        _labelInfo = info;
        _isLoading = false; // Set loading state to false when data is fetched
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Set loading state to false if there's an error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to home screen directly when back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavWithAnimations()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/detectorbackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/loading_animation.json',
                        // Replace with your Lottie animation file path
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        // Close the camera session and the app
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavWithAnimations())); // Pop until the root route
                                      },
                                      icon: Icon(Icons.arrow_back),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Detected Species',
                                    style: TextStyle(
                                      color: Color(0xFF50E4FF),
                                      fontSize: 25,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 36), // Adjust the width as needed
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: CarouselWithTigerIndicator(
                                  detectedLabel: widget.detectedLabel),
                            ),
                            SizedBox(height: 30),
                            Image(
                              image: AssetImage('assets/images/line.png'),
                              width: 350,
                            ),
                            SizedBox(height: 20),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Center(
                                child: Text(
                                  'ABOUT',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 15.0),
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w300,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              _labelInfo, // Display label information
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  'Source: Wikipedia',
                                  style: TextStyle(
                                      color: Color(0xFF2196F3),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Image(
                              image: AssetImage('assets/images/line.png'),
                              width: 350,
                            ),
                            SizedBox(height: 20),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Center(
                                child: Text(
                                  'GRAPH VISUALIZATION',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: LineChartSample2(),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
