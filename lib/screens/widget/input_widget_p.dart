import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputWidgetPassword extends StatefulWidget {
  const InputWidgetPassword(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.obscureText})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  State<InputWidgetPassword> createState() => _InputWidgetPasswordState();
}

class _InputWidgetPasswordState extends State<InputWidgetPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: _obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
