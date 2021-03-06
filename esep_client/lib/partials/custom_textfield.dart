import 'package:flutter/material.dart';

class XSEPTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;
  final Function suffixIconOnTap;
  final TextEditingController controller;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final Iterable<String> autofillHints;

  const XSEPTextField({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
    this.suffixIconOnTap,
    this.controller,
    this.validator,
    this.keyboardType,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 14.0,
        ),
        cursorColor: Colors.blueGrey,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: Icon(
            prefixIconData,
            size: 18,
            color: Colors.blueGrey,
          ),
          filled: true,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          suffixIcon: GestureDetector(
            onTap: suffixIconOnTap,
            child: Icon(
              suffixIconData,
              size: 18,
              color: Colors.blue,
            ),
          ),
          labelStyle: TextStyle(color: Colors.blueGrey),
          focusColor: Colors.blueGrey,
        ),
        onChanged: onChanged,
        keyboardType: keyboardType,
        //autofillHints: autofillHints,
      ),
    );
  }
}
