import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const OtpInputField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 4,
      obscureText: false, // Set obscureText to false
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontFamily: 'SF Pro',
      ),
      animationDuration: const Duration(milliseconds: 300),
      onChanged: onChanged,
      appContext: context,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(20),
        fieldWidth: 50,
        fieldHeight: 50,
        activeColor: Colors.white,
        inactiveColor: Colors.white, // Ensure inactive color is set to white or transparent
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
    );
  }
}
