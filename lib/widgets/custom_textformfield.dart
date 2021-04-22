import 'package:flutter/material.dart';

import '../config/colors.dart';

TextFormField buildTextFormField(
  Function onEditingComplete,
  String hintText,
  Function validator, {
  bool isPassword = false,
  TextInputType keyboardType,
  Function onFieldSubmitted,
}) {
  return TextFormField(
    onEditingComplete: onEditingComplete,
    obscureText: isPassword,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: FitwithColors.getBasicOrange()),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: FitwithColors.getBasicOrange()),
      ),
      errorStyle: TextStyle(
        color: FitwithColors.getBasicOrange(),
      ),
    ),
    validator: validator,
    keyboardType: keyboardType,
    onFieldSubmitted: onFieldSubmitted,
  );
}
