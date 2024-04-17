import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildsense/pages/about_us.dart';
import 'package:wildsense/screens/dashboardpages/profilescreen/userprofile/userprofile.dart';
import 'package:wildsense/widget/profilescreen/profilescreencontent.dart';

import '../../screens/loginpage/loginscreen.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileScreenContent(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildAccountInfoContainer(
              title: 'Personal Details',
              onPressed: () {
                print('Navigating to Personal Details');
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
              },
            ),
            _buildAccountInfoContainer(
              title: 'About Us',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUsPage()));
              },
            ),
            _buildAccountInfoContainer(
              title: 'FAQs and Help',
              onPressed: () {
                // Handle FAQ button pressed
              },
            ),
            _buildAccountInfoContainer(
              title: 'Terms & Condition',
              onPressed: () {
                // Handle FAQ button pressed
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 40,
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF6D358D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _logout(context);
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logging out...'),
        duration: Duration(seconds: 2),
      ),
    );
    await FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      print('Error logging out: $error');
    });
  }

  Widget _buildAccountInfoContainer(
      {required String title, required VoidCallback onPressed}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
