import 'package:flutter/material.dart';
import 'package:wildsense/widget/homescreen/welcome_content.dart';
import '../curved_edges/curved_edges_widget.dart';
import '../custom_container/circular_container.dart';

class WelcomeScreenContent extends StatelessWidget {
  const WelcomeScreenContent({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CurvedEdgesWidget(
          child: Container(
            color: const Color(0xFF3A174C),
            padding: const EdgeInsets.only(bottom: 0),
            child: SizedBox(
              height: 350,
              child: Stack(
                children: [
                  Positioned(
                    top: -150,
                    right: -250,
                    child: CircularContainer(
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: -300,
                    child: CircularContainer(
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: 90, // Adjust the position as needed
          left: 5,
          right: 5, // Adjust the position as needed
          child: WelcomeContent(), // Add the WelcomeContent widget
        ),
      ],
    );
  }
}
