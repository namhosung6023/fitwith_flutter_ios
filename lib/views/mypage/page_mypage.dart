import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/mypage/survey/page_first_survey.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Consumer<User>(builder: (context, user, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원 정보',
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25.0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 2.0,
                    color: FitwithColors.getSecondary200(),
                  ),
                ),
                child: Image.asset(
                  user.avatar == '' ? 'assets/addProfile.png' : user.avatar,
                  width: 160.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildProfileContents('성명', user.username, false),
            _buildProfileContents('나이', '${user.age}', false),
            _buildProfileContents('이메일', user.email, false),
            _buildProfileContents('전화번호', '본인인증', true),
            _buildProfileContents('주소', '주소찾기', true),
            SizedBox(height: 40.0),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: FitwithColors.getPrimaryColor(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '트레이너 지원하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => CommonUtils.movePage(
                context,
                FirstSurveyPage(),
              ),
            ),
            SizedBox(height: 40.0),
          ],
        );
      }),
    );
  }

  Widget _buildProfileContents(String title, String contents, bool isButton) {
    return Container(
      padding: isButton
          ? EdgeInsets.symmetric(vertical: 5.0)
          : EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 90.0,
            child: Text(
              title,
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isButton
              ? InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 40.0,
                    ),
                    decoration: BoxDecoration(
                      color: FitwithColors.getSecondary200(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      contents,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('tap');
                  },
                )
              : Text(
                  contents,
                  style: TextStyle(
                    color: FitwithColors.getSecondary400(),
                    fontSize: 16.0,
                  ),
                ),
        ],
      ),
    );
  }
}
