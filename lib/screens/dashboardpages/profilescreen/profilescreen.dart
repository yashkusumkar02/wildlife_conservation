import 'package:flutter/material.dart';
import '../../../../widget/profilescreen/profilecontent.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ProfileContent(), // Display profile content widget
          ),
        ],
      ),
    );
  }
}
