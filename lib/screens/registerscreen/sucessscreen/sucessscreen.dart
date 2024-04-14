import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/fade_animation.dart';
import '../../../widget/custome_widget.dart';
import '../../loginpage/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser?.reload(), // Reload the user data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for Firebase response, show a loading indicator
          return CircularProgressIndicator();
        } else {
          // After Firebase response is received
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // If user is registered, navigate to login screen
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/newbackground.png',
                      fit: BoxFit.cover,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Image.asset(
                                  'assets/images/account.png',
                                  height: 250,
                                  width: 230,
                                ),
                              ),
                              const Text(
                                'Your Account Successfully Created!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Image.asset(
                                'assets/images/rounded.png',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 50, right: 40, left: 40, bottom: 20),
                                child: Column(
                                  children: [
                                    const Center(
                                      child: FadeInAnimation(
                                        delay: 1.4,
                                        child: Text(
                                          "Welcome to Your Wild-Sense. Your Account is Created. Enjoy , Identify and Share the knowledge about Wildlife Conservation with your Friends..!!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    FadeInAnimation(
                                      delay: 1.9,
                                      child: CustomElevatedButton(
                                        message: 'Get Started!',
                                        function: () {
                                          // Navigate to the LoginScreen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                        gradientColors: const [
                                          Color(0xFF9C3FE4),
                                          Color(0xFFC65647),
                                        ],
                                        borderRadius: 30.0,
                                        elevation: 8.0,
                                        height: 50.0,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // If user is not registered, return an empty container
          return Container();
        }
      },
    );
  }
}
