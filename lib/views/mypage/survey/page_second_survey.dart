import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_checklist.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/mypage/survey/page_second_survey.dart';
import 'package:fitwith/widgets/custom_checkboxInput.dart';
import 'package:fitwith/widgets/custom_checkbox_tile.dart';
import 'package:fitwith/widgets/custom_checklist_Item.dart';
import 'package:fitwith/widgets/custom_outlined_textfield.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kopo/kopo.dart';

class SecondSurveyPage extends StatefulWidget {
  @override
  _SecondSurveyPageState createState() => _SecondSurveyPageState();
}

class _SecondSurveyPageState extends State<SecondSurveyPage> {
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
                  '님의',
                  style: TextStyle(
                    color: FitwithColors.getSecondary400(),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Text(
              '활동장소를 알려주세요.',
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '가까운 거리의 회원님이 쉽게 찾을 수 있습니다.',
              style: TextStyle(
                color: FitwithColors.getSecondary300(),
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 60.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '주소',
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            InkWell(
              onTap: () async {
                KopoModel model = await CommonUtils.movePage(context, Kopo());
                print(model.toJson());
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: FitwithColors.getSecondary200()),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.search,
                          color: FitwithColors.getSecondary200(),
                        ),
                      ),
                      Text(
                        '뚝섬로 13길, 38',
                        style: TextStyle(
                          color: FitwithColors.getSecondary400(),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              style: TextStyle(
                color: FitwithColors.getSecondary300(),
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 20.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: FitwithColors.getSecondary200()),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: FitwithColors.getSecondary300()),
                ),
                labelText: '상세 주소 입력',
                labelStyle: TextStyle(
                  color: FitwithColors.getSecondary200(),
                  fontSize: 16.0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 50.0),
            Image.asset(
              'assets/weet_map.png',
              height: 180.0,
              width: 180.0,
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 30.0,
                    ),
                    decoration: BoxDecoration(
                      color: FitwithColors.getSecondary200(),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text(
                      '이전',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
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
                  onTap: () =>
                      CommonUtils.movePage(context, SecondSurveyPage()),
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
