import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../pages/chatbot.dart';
import '../../../widget/homescreen/home_content.dart';
import 'dragglebutton/draggable.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset(
                'assets/images/logo1.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        body: const SingleChildScrollView(child: HomeContent()), // Removed unnecessary const
        // Wrap DraggableFab with Showcase and pass the GlobalKey
        floatingActionButton: DraggableFab(),
    );
  }
}
