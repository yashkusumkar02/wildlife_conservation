import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/images_string.dart';

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 180.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: [
            WildSenseImages.wildlifebanner1,
            WildSenseImages.wildlifebanner2,
            WildSenseImages.wildlifebanner3,
            WildSenseImages.wildlifebanner4,
            WildSenseImages.wildlifebanner5,
          ].map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: 5, // Provide a fixed number of dots for the Carousel
          effect: const ExpandingDotsEffect(
            dotWidth: 8.0,
            dotHeight: 8.0,
            activeDotColor: Color(0xFF3A174C),
            dotColor: Colors.black54
          ), // You can change the effect if needed
        ),
      ],
    );
  }
}
