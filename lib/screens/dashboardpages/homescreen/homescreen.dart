import 'package:flutter/material.dart';
import '../../../pages/chatbot.dart';
import '../../../widget/homescreen/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: const SingleChildScrollView(child: HomeContent()),
      floatingActionButton: DraggableFab(),
    );
  }
}

class DraggableFab extends StatefulWidget {
  @override
  _DraggableFabState createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = Offset(300, 680); // Initial position of the button
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position += details.delta;
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotChatScreen()),
                );
              },
              child: Icon(Icons.chat),
            ),
          ),
        ),
      ],
    );
  }
}
