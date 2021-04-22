import 'package:flutter/material.dart';

Widget buildScaffold(
  BuildContext context,
  Widget child, {
  Color backgroundColor = Colors.white,
  AppBar appBar,
  Widget drawer,
  Widget endDrawer,
  GlobalKey<ScaffoldState> key,
}) {
  return Scaffold(
    backgroundColor: backgroundColor,
    appBar: appBar,
    drawer: drawer,
    endDrawer: endDrawer,
    body: SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: child,
      ),
    ),
    key: key,
  );
}
