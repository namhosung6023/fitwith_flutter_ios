import 'package:flutter/material.dart';

Widget buildLoading({Color color = Colors.black}) {
  return Container(
    child: Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false, color: color),
        ),
        Center(
          child: Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              image: DecorationImage(
                scale: 8.0,
                image: AssetImage("assets/loading.gif"),
              ),
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ],
    ),
  );
}
