import 'package:flutter/material.dart';
import 'package:wildsense/widget/homescreen/welcome_screen_container.dart';
import '../../pages/articles.dart';
import '../../pages/speciesnearby.dart';
import '../indicator/carousel_indicator.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const WelcomeScreenContent(),
            const Text(
              'FEATURED CONTENT',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: "SF Pro",
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CarouselWithIndicator(),
                  const SizedBox(height: 40),
                  const Text(
                    'SPECIES NEARBY',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: "SF Pro",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SpeciesNearby(),
                  const SizedBox(height: 40),
                  const Text(
                    'ARTICLES',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: "SF Pro",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20), // Adjust the spacing here
                  ListViewBuilder(), // Use ListViewBuilder directly here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
