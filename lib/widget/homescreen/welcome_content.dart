import 'package:flutter/material.dart';
import 'package:wildsense/screens/dashboardpages/scanandidentify/camerascreen.dart';

class WelcomeContent extends StatefulWidget {

  const WelcomeContent({Key? key}) : super(key: key);


  @override
  _WelcomeContentState createState() => _WelcomeContentState();
}

class _WelcomeContentState extends State<WelcomeContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF635BD3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return const Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Center(
        child: Text(
          "Detect Species",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.50,
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return const Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Center(
        child: Text(
          "Scan & identify Animals / Birds Species anywhere, anytime from all over the world.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.50,
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return Positioned(
      top: 90,
      left: 50,
      right: 50,
      child: GestureDetector(
        onTap: () {
          try {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DummyContainer()));
          } catch (e) {
            print('Error navigating to scan image screen: $e');
          }
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF9C3FE4), Color(0xFFC65647)],
            ),
          ),
          child: const Center(
            child: Text(
              '📸 Scan/Identify a Species',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: const Text(
            "Welcome to Wild-Sense",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20, // Adjust the height according to your needs
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            width: 300,
            height: 140,
            child: Stack(
              children: [
                _buildBackgroundContainer(),
                _buildTitleText(),
                _buildDescriptionText(),
                _buildScanButton(context), // Pass the context here
              ],
            ),
          ),
        ),
      ],
    );
  }
}
