import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wildsense/screens/videoscreen/videoscreen.dart'; // Import your video screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigate(); // Call the navigate function
  }

  Future<void> _navigate() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if splash screen was already visited
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool visitedSplash = prefs.getBool('visitedSplash') ?? false;

    if (visitedSplash) {
      // Navigate to VideoScreen if splash screen was visited before
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VideoScreen()),
      );
    } else {
      // Mark splash screen as visited
      await prefs.setBool('visitedSplash', true);

      // Navigate to VideoScreen after marking splash screen as visited
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VideoScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgroundimage.png',
                fit: BoxFit.cover,
              ),
            ),
            // Centered Content
            Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Wild-Sense',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'The Incredible Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
