import 'package:fitwith/config/colors.dart';
import 'package:fitwith/views/mypage/survey/page_first_survey.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ApplyTrainerPage extends StatefulWidget {
  @override
  _ApplyTrainerPageState createState() => _ApplyTrainerPageState();
}

class _ApplyTrainerPageState extends State<ApplyTrainerPage> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      context,
      _buildBody(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: FitwithColors.getSecondary300()),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/logo_blue.png',
          height: 25,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FirstSurveyPage();
  }
}
