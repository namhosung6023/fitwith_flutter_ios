import 'package:fitwith/config/colors.dart';
import 'package:flutter/material.dart';

Widget buildBlankPage(String comment) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/cry_weet.png',
        height: 100.0,
      ),
      SizedBox(height: 20.0),
      Text(
        comment,
        style: TextStyle(
          color: FitwithColors.getSecondary200(),
          fontSize: 18.0,
        ),
      ),
    ],
  );
}
