import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wildsense/screens/dashboardpages/homescreen/homescreen.dart';
import 'package:wildsense/screens/dashboardpages/profilescreen/profilescreen.dart';
import 'package:wildsense/screens/registerscreen/phoneverification/phoneverification.dart';
import 'package:wildsense/screens/registerscreen/registerscreen.dart';
import 'package:wildsense/screens/loginpage/loginscreen.dart';
import 'package:wildsense/screens/splashscreen/splashscreen.dart';
import 'package:wildsense/screens/videoscreen/videoscreen.dart';
import 'package:wildsense/screens/welcomepage/welcome_screen.dart';
import 'firebase_options.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  cameras= await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  Widget initialScreen;
  if (user != null) {
    // Check if the user exists in the Firestore database
    bool userExists = await isUserExistsInDatabase(user.uid);
    if (userExists) {
      initialScreen = HomeScreen(); // User is already logged in but not in the database
    } else {
      initialScreen = HomeScreen(); // User is already logged in and exists in the database
    }
  } else {
    // Check if it's the user's first time opening the app
    bool isFirstTimeUser = await isFirstTimeUserCheck();
    if (isFirstTimeUser) {
      initialScreen = SplashScreen(); // Show splash screen for first-time users
    } else {
      // Check if the user is registered in the database
      bool isRegisteredUser = await isRegisteredUserInDatabase();
      if (isRegisteredUser) {
        initialScreen = LoginPage(); // User is not logged in but registered in the database
      } else {
        initialScreen = LoginPage(); // User is not logged in and not registered, show login page
      }
    }
  }

  runApp(MyApp(initialScreen: initialScreen));
}

// Function to check if it's the user's first time opening the app
Future<bool> isFirstTimeUserCheck() async {
  // Initialize shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the flag indicating first-time user exists
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // If it's the first time, set the flag to false for future launches
  if (isFirstTime) {
    prefs.setBool('isFirstTime', false);
  }

  // Return the isFirstTime flag
  return isFirstTime;
}

// Function to check if the user exists in the Firestore database
Future<bool> isUserExistsInDatabase(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userSnapshot.exists;
  } catch (e) {
    print('Error checking user existence: $e');
    return false;
  }
}

// Function to check if the user is registered in the database
Future<bool> isRegisteredUserInDatabase() async {
  // Implement your logic to check if the user is registered in the database
  // For example, you can check if there are any documents in the users collection
  try {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    return usersSnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking registered user in database: $e');
    return false;
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => initialScreen,
        '/videoscreen': (context) => const VideoScreen(),
        '/welcomepage': (context) => const WelcomePage(),
        '/registerpage': (context) => RegisterPage(),
        '/loginpage': (context) => const LoginPage(),
        '/emailverify': (context) => PhoneVerification(
          registeredPhoneNumber: '', // Provide registeredPhoneNumber
          verificationId: '', // Provide verificationId
          auth: FirebaseAuth.instance, // Provide FirebaseAuth instance
          // Inside the resendOtpCallback function
          resendOtpCallback: () async {
            String registeredPhoneNumber =
                ''; // Initialize it with the registered phone number

            // Implement the logic to resend OTP
            try {
              // Use Firebase Auth to resend OTP
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: registeredPhoneNumber,
                verificationCompleted: (PhoneAuthCredential credential) {
                  // Handle verification completion if needed
                },
                verificationFailed: (FirebaseAuthException e) {
                  // Handle verification failure if needed
                },
                codeSent: (String verificationId, int? resendToken) {
                  // Handle code sent (optional)
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  // Handle code auto retrieval timeout (optional)
                },
              );
              // Show a success message or perform any other action
              print('OTP has been resent successfully');
            } catch (e) {
              // Handle errors if any
              print('Error resending OTP: $e');
            }
          },
        ),
        '/profilepage': (context) => const ProfileScreen(),
        '/home' : (context) => const HomeScreen(),
        // Remove cameras parameter from here
      },
    );
  }
}
