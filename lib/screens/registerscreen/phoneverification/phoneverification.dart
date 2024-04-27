import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wildsense/screens/loginpage/loginscreen.dart';
import '../../../common/fade_animation.dart';
import '../../../widget/custome_widget.dart';
import '../sucessscreen/sucessscreen.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({
    Key? key,
    required this.registeredPhoneNumber,
    required this.verificationId,
    required this.auth,
    required this.resendOtpCallback,
    this.email,
    this.name,
    this.password,
  }) : super(key: key);

  final String registeredPhoneNumber;
  final String verificationId;
  final FirebaseAuth auth;
  final Function() resendOtpCallback;
  final String? email;
  final String? name;
  final String? password;

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  late TextEditingController _otpController;
  late String verificationId;
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    verificationId = widget.verificationId;
    _auth = widget.auth;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Do you want to discard the entered data and go back?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  void _verifyOtp() async {
    if (_otpController.text.length == 6) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: _otpController.text,
        );

        await _auth.signInWithCredential(credential);

        Get.off(() => const SuccessScreen()); // Changed here
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to verify OTP: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            'assets/images/otp.png',
                            height: 230,
                            width: 230,
                          ),
                        ),
                        Text(
                          'Verify your Phone Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/rounded.png',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 80,
                            right: 40,
                            left: 40,
                            bottom: 20,
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: FadeInAnimation(
                                  delay: 1.2,
                                  child: Text(
                                    widget.registeredPhoneNumber ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              FadeInAnimation(
                                delay: 1.4,
                                child: Text(
                                  "Please enter the OTP sent to your Mobile Number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FadeInAnimation(
                                delay: 2.0,
                                child: TextFormField(
                                  controller: _otpController,
                                  onChanged: (value) {
                                    _verifyOtp();
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Enter OTP',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomElevatedButton(
                                message: 'Verify OTP',
                                function: _verifyOtp,
                                gradientColors: const [
                                  Color(0xFF9C3FE4),
                                  Color(0xFFC65647),
                                ],
                                borderRadius: 30.0,
                                elevation: 8.0,
                                height: 50.0,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  widget.resendOtpCallback();
                                },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () async {
                              bool goBack = await _onWillPop();
                              if (goBack) {
                                Navigator.pop(context);
                              }
                            },
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
      ),
    );
  }
}
