import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wildsense/screens/loginpage/loginscreen.dart';
import 'package:wildsense/screens/registerscreen/phoneverification/phoneverification.dart';
import '../../common/fade_animation.dart';
import '../../widget/custome_widget.dart';
import '../../widget/totastmessage/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _privacyAccepted = ValueNotifier<bool>(false);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';
  bool _isLoading = false; // Add isLoading state

  void _register(BuildContext context) async {
    if (!_privacyAccepted.value) {
      showCustomToast(
        message: "Please accept the privacy policy",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loader when registration starts
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Set display name for the user
        await userCredential.user!.updateDisplayName(_nameController.text.trim());

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone_number': _phoneNumberController.text.trim(),
          // Add other user data fields as needed
        });

        // Navigate to phone verification screen
        await _verifyPhoneNumber(context);
      } catch (e) {
        print("Failed to register user: $e");
        // Handle registration errors
        showCustomToast(
          message: "Failed to register user: $e",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loader when registration completes
        });
      }
    }
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneNumberController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Authentication completed automatically
        // You can navigate to the next screen or perform any other action
      },
      verificationFailed: (FirebaseAuthException e) {
        showCustomToast(
          message: "Failed to verify phone number: ${e.message}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerification(
              registeredPhoneNumber: _phoneNumberController.text,
              verificationId: verificationId,
              auth: _auth,
              resendOtpCallback: () {},
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout
      },
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateUppercase(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    return null;
  }

  String? validateLowercase(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    return null;
  }

  String? validateLength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateSpecialCharacter(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Image.asset(
                            'assets/images/character2.png',
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/rounded.png',
                          fit: BoxFit.scaleDown,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              const Center(
                                child: FadeInAnimation(
                                  delay: 1,
                                  child: Text(
                                    'Get Started Free',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              FadeInAnimation(
                                delay: 1.3,
                                child: Text(
                                  'Create your Account 😎',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FadeInAnimation(
                                delay: 1.6,
                                child: CustomTextFormField(
                                  controller: _nameController,
                                  hinttext: 'Enter your Name',
                                  obsecuretext: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    } else if (value.trim().length < 2) {
                                      return 'Name must be at least 2 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FadeInAnimation(
                                delay: 1.6,
                                child: CustomTextFormField(
                                  controller: _emailController,
                                  hinttext: 'Enter your Email',
                                  obsecuretext: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!EmailValidator.validate(
                                        value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FadeInAnimation(
                                delay: 1.6,
                                child: CustomTextFormField(
                                  controller: _phoneNumberController,
                                  hinttext: 'Enter your Phone Number (+91)',
                                  obsecuretext: false,
                                  validator: validatePhoneNumber,
                                  prefixText: '+91',
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FadeInAnimation(
                                delay: 1.6,
                                child: CustomTextFormField(
                                  controller: _passwordController,
                                  hinttext: 'Enter your Password',
                                  obsecuretext: true,
                                  validator: (value) {
                                    String? error;
                                    error ??= validateUppercase(value);
                                    error ??= validateLowercase(value);
                                    error ??= validateLength(value);
                                    error ??= validateSpecialCharacter(value);
                                    return error;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              FadeInAnimation(
                                delay: 1.6,
                                child: CustomTextFormField(
                                  controller: _confirmPasswordController,
                                  hinttext: 'Confirm Password',
                                  obsecuretext: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FadeInAnimation(
                                delay: 2.0,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _privacyAccepted,
                                  builder: (context, accepted, child) {
                                    if (_privacyAccepted != null) {
                                      return CheckboxListTile(
                                        title: const Text(
                                          'I accept the privacy policy',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        value: accepted ?? false,
                                        onChanged: (value) {
                                          _privacyAccepted.value =
                                              value ?? false;
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                        activeColor: Colors.white,
                                        checkColor: Colors.black,
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FadeInAnimation(
                                delay: 2.3,
                                child: Stack(
                                  children: [
                                    CustomElevatedButton(
                                      function: () {
                                        if (_formKey.currentState!.validate() &&
                                            _privacyAccepted.value) {
                                          _register(context);
                                        } else {
                                          showCustomToast(
                                            message:
                                            "Please fill all the fields and accept the privacy policy",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        }
                                      },
                                      message: 'Register',
                                      gradientColors: const [
                                        Color(0xFF9C3FE4),
                                        Color(0xFFC65647),
                                      ],
                                      borderRadius: 30.0,
                                      elevation: 8.0,
                                      height: 50.0,
                                      width: double.infinity,
                                    ),
                                    if (_isLoading)
                                      Positioned.fill(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
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
                                      "Already have an Account?",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'SF Pro',
                                          fontSize: 16),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/loginpage');
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'SF Pro',
                                            fontSize: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}
