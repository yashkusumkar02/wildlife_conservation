import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wildsense/screens/loginpage/loginscreen.dart';
import 'package:wildsense/screens/registerscreen/registerscreen.dart';
import '../../../common/fade_animation.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
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
                          fontWeight: FontWeight.w700,
                        ),
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
                          top: 50,
                          right: 40,
                          left: 40,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            const Center(
                              child: FadeInAnimation(
                                delay: 1.4,
                                child: Text(
                                  "Welcome to Your Wild-Sense. Your Account is Created. Enjoy, Identify and Share the knowledge about Wildlife Conservation with your Friends..!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInAnimation(
                              delay: 1.9,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to the LoginPage
                                  Get.off(() =>  LoginPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Color(0xFFC65647), backgroundColor: Color(0xFF9C3FE4), // Foreground color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0), // Rounded border
                                  ),
                                  elevation: 8.0, // Elevation
                                ),
                                child: SizedBox(
                                  height: 50.0,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      'Get Started!',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
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
}
