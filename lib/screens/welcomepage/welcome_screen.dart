import 'package:flutter/material.dart';
import '../../widget/rotating_images.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundimage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Login assets
          Column(
            children: [
              const SizedBox(height: 100),
              const LoginAssets(),
              const SizedBox(height: 50),
              const Text(
                'Welcome to Wild-Sense',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                        text: "Wildlife is an important part of nature, ",
                        style: mainWhite),
                    TextSpan(
                      text:
                          "and it is important to protect it for future generations.",
                      style: white,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Container(
                  width: double.infinity, // Set width to match the button width
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C3FE4), Color(0xFFC65647)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loginpage');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      // Set background color to transparent
                      overlayColor: MaterialStateProperty.all<Color>(Colors
                          .transparent), // Set overlay color to transparent
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0), // Adjust padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Container(
                  width: double.infinity, // Set width to match the button width
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 43, 107, 255),
                        Color.fromARGB(255, 133, 57, 255)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registerpage');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      // Set background color to transparent
                      overlayColor: MaterialStateProperty.all<Color>(Colors
                          .transparent), // Set overlay color to transparent
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0), // Adjust padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color mainColor = const Color(0xFFAF8994);
TextStyle white = const TextStyle(
    fontSize: 14,
    fontFamily: "Quicksand",
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(255, 255, 255, 0.82));
TextStyle mainWhite = const TextStyle(
    fontSize: 16,
    fontFamily: "Quicksand",
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(255, 255, 255, 0.82));
