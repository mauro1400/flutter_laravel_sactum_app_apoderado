import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputWidgetEmail extends StatefulWidget {
  const InputWidgetEmail(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.obscureText})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  State<InputWidgetEmail> createState() => _InputWidgetEmailState();
}

class _InputWidgetEmailState extends State<InputWidgetEmail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          suffixIcon: const Icon(Icons.person),
        ),
      ),
    );
  }
}
