import 'package:fitwith/config/colors.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/mypage/survey/page_second_survey.dart';
import 'package:fitwith/widgets/custom_checkboxInput.dart';
import 'package:fitwith/widgets/custom_checkbox_tile.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class FirstSurveyPage extends StatefulWidget {
  @override
  _FirstSurveyPageState createState() => _FirstSurveyPageState();
}

class _FirstSurveyPageState extends State<FirstSurveyPage> {
  List<String> _field = [];
  bool _isEtcField = false;
  String _etcField = '';

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
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '건강 전문가',
                  style: TextStyle(
                    color: FitwithColors.getPrimaryColor(),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '님 반갑습니다!',
                  style: TextStyle(
                    color: FitwithColors.getSecondary400(),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              '진행하고자 하는 트레이닝에 대해 알려주세요',
              style: TextStyle(
                color: FitwithColors.getSecondary300(),
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 40.0),
            CustomCheckboxTile(
              title: '퍼스널 트레이닝',
              value: _field.where((item) => item == '퍼스널 트레이닝').isNotEmpty,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _field.add('퍼스널 트레이닝');
                  } else {
                    _field.removeWhere((item) => item == '퍼스널 트레이닝');
                  }
                });
                print(_field);
              },
              fontSize: 18.0,
              paddingVertical: 10.0,
              paddingCenter: 15.0,
              isBig: true,
            ),
            Divider(),
            CustomCheckboxTile(
              title: '영양/식단 관리',
              value: _field.where((item) => item == '영양/식단 관리').isNotEmpty,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _field.add('영양/식단 관리');
                  } else {
                    _field.removeWhere((item) => item == '영양/식단 관리');
                  }
                });
                print(_field);
              },
              fontSize: 18.0,
              paddingVertical: 10.0,
              paddingCenter: 15.0,
              isBig: true,
            ),
            Divider(),
            CustomCheckboxTile(
              title: '필라테스',
              value: _field.where((item) => item == '필라테스').isNotEmpty,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _field.add('필라테스');
                  } else {
                    _field.removeWhere((item) => item == '필라테스');
                  }
                });
                print(_field);
              },
              fontSize: 18.0,
              paddingVertical: 10.0,
              paddingCenter: 15.0,
              isBig: true,
            ),
            Divider(),
            CustomCheckboxTile(
              title: '요가',
              value: _field.where((item) => item == '요가').isNotEmpty,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _field.add('요가');
                  } else {
                    _field.removeWhere((item) => item == '요가');
                  }
                });
                print(_field);
              },
              fontSize: 18.0,
              paddingVertical: 10.0,
              paddingCenter: 15.0,
              isBig: true,
            ),
            Divider(),
            CustomCheckboxInput(
              title: '기타(직접입력)',
              value: _isEtcField,
              onChanged: (value) {
                print(_etcField);
                setState(() {
                  _isEtcField = value;
                  if (!value) {
                    _etcField = '';
                  }
                });
              },
              onEditingComplete: (value) {
                setState(() {
                  if (value.trim == '') {
                    _isEtcField = false;
                  } else {
                    _etcField = value;
                  }
                });
                print(_etcField);
              },
            ),
            Divider(),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 30.0,
                    ),
                    decoration: BoxDecoration(
                      color: FitwithColors.getPrimaryColor(),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => CommonUtils.movePage(
                      context,
                      SecondSurveyPage(
                        field: _field,
                        etcField: _etcField,
                      )),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
