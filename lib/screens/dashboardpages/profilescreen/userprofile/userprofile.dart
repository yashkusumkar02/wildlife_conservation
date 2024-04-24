import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<void> userDataFuture;
  late String name = '';
  late String email = '';
  late String phoneNumber = '';
  late String gender = ''; // Initialize gender
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          name = userDoc.get('name') ?? '';
          email = userDoc.get('email') ?? '';
          phoneNumber = userDoc.get('phone_number') ?? ''; // Corrected field name
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundimage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Update Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/images/avatar.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  // Implement edit profile functionality
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Image(
                    image: AssetImage('assets/images/line.png'),
                    width: 350,
                  ),
                  SizedBox(height: 30),
                  FutureBuilder<void>(
                    future: userDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            TextFormField(
                              initialValue: name,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                suffixIcon: Icon(Icons.edit, color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: email,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                suffixIcon: Icon(Icons.edit, color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: phoneNumber,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                suffixIcon: Icon(Icons.edit, color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: '', // No initial value for gender
                              onChanged: (newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              },
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: 'Enter your gender',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                suffixIcon: Icon(Icons.edit, color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                // Implement the button functionality
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero,
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                elevation: MaterialStateProperty.all<double>(2),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              ),
                              child: Container(
                                width: 346,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(1.00, -0.01),
                                    end: Alignment(-1, 0.01),
                                    colors: [Color(0xFF9C3FE4), Color(0xFFC65647)],
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
