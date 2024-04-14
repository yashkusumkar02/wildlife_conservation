import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hinttext;
  final bool obsecuretext;
  final String? prefixText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    required this.hinttext,
    required this.obsecuretext,
    this.prefixText,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obsecuretext,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hinttext,
        hintStyle: TextStyle(color: Colors.white),
        prefixText: widget.prefixText,
      ),
      style: TextStyle(color: Colors.white),
      validator: widget.validator,
    );
  }
}


class CustomElevatedButton extends StatefulWidget {
  final String message;
  final Function() function;
  final List<Color> gradientColors;
  final double borderRadius;
  final double elevation;
  final double height;
  final double width;
  final bool formIsValid;

  const CustomElevatedButton({
    Key? key,
    required this.message,
    required this.function,
    required this.gradientColors,
    required this.borderRadius,
    required this.elevation,
    required this.height,
    required this.width,
    this.formIsValid = true, // Provide a default value
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ElevatedButton(
        onPressed: widget.formIsValid
            ? () async {
          setState(() {
            loading = true;
          });
          await widget.function();

          setState(() {
            loading = false;
          });
        }
            : null, // Disable button if form is invalid
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(widget.elevation),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ),
        child: loading
            ? const CircularProgressIndicator() // Show loading indicator
            : Text(
          widget.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
