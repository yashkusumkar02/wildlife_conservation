import 'package:flutter/material.dart';

import '../../../widget/homescreen/home_content.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.0,
              ),
            );
          },
        ),
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
    );
  }
}

