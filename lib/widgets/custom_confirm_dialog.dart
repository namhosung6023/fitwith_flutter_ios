import 'package:fitwith/config/colors.dart';
import 'package:fitwith/utils/utils_widget.dart';
import 'package:flutter/material.dart';

Widget buildConfirmDialog(
    BuildContext context, Widget title, Widget content, Function func) {
  return AlertDialog(
    titlePadding: EdgeInsets.only(top: 40),
    contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 10),
    actionsPadding: EdgeInsets.fromLTRB(30, 0, 30, 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
    title: title,
    content: content,
    actions: <Widget>[
      Row(
        children: [
          Align(
            // alignment: Alignment.center,
            child: WidgetUtils.buildDefaultButton2(
              '취소',
              () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: 10),
          Align(
            // alignment: Alignment.center,
            child: WidgetUtils.buildDefaultButton1(
              '확인',
              () {
                func();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ],
  );
}
