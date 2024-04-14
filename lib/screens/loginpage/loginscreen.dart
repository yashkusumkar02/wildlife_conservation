import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:wildsense/screens/dashboardpages/homescreen/homescreen.dart';
import 'package:wildsense/screens/registerscreen/registerscreen.dart';
import '../../common/fade_animation.dart';
import '../../widget/custome_widget.dart';
import '../../widget/totastmessage/fluttertoast.dart';
import '../dashboardpages/profilescreen/profilescreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool showPassword = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    // Check if the user is already logged in
    checkCurrentUser();
  }

  // Function to check if the user is already logged in
  void checkCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to handle login button pressed
  void handleLogin() async {
    try {
      // Show a Snackbar indicating that the user is logging in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logging in...'), // Show logging in message
          duration: Duration(seconds: 2), // Set duration
        ),
      );

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user details
      User? user = userCredential.user;

      // Show a toast message indicating successful login and user details verification
      showCustomToast(
        message: "Login successful. User details verified: ${user?.email}",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Login successful, navigate to profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Login failed, show error message
      showCustomToast(
        message: "Login failed: ${e.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/newbackground.png',
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/images/character1.png',
                    ),
                  ),
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/rounded.png',
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const Center(
                              child: FadeInAnimation(
                                delay: 1.2,
                                child: Text(
                                  'Welcome Back!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const FadeInAnimation(
                              delay: 1.4,
                              child: Text(
                                'Login with your Credentials 😇',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FadeInAnimation(
                              delay: 1.6,
                              child: CustomTextFormField(
                                hinttext: 'Enter Email',
                                obsecuretext: false,
                                controller: emailController,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FadeInAnimation(
                              delay: 1.8,
                              child: TextFormField(
                                obscureText: !showPassword,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(18),
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: Icon(
                                      showPassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                controller: passwordController,
                              ),
                            ),
                            FadeInAnimation(
                              delay: 2.0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Forget Password?",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FadeInAnimation(
                              delay: 2.2,
                              child: CustomElevatedButton(
                                message: 'Login',
                                gradientColors: const [
                                  Color(0xFF9C3FE4),
                                  Color(0xFFC65647),
                                ],
                                borderRadius: 30.0,
                                elevation: 8.0,
                                height: 50.0,
                                width: double.infinity,
                                function: handleLogin,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInAnimation(
                              delay: 2.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an Account?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'SF Pro',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
