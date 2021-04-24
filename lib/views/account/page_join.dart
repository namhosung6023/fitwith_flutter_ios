import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fitwith/api/api_account.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/account/page_survey.dart';
import 'package:fitwith/views/page_root.dart';
import 'package:fitwith/widgets/custom_checkbox_tile.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_outlined_textfield.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> _user = {
    'username': '',
    'email': '',
    'password': '',
    'avatar': '',
    'gender': '',
    'age': '',
  };

  String _password = '';
  bool _autoValidate = false;

  bool _loading = false;
  Size _deviceSize;

  bool _agreementPrivacy = false; // 개인정보 이용 동의
  bool _agreementMarketing = false; // 마케팅 활용 동의

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _join() async {
    if (_formKey.currentState.validate()) {
      if (_agreementPrivacy != true)
        return buildSnackBar(context, '개인정보 이용 동의는 필수입니다.');

      setState(() => _loading = true);

      _user['password'] = sha512.convert(utf8.encode(_password)).toString();
      Map<String, dynamic> res = await postJoin(_user);

      if (res['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['accesstoken']);
        CommonUtils.movePage(context, RootPage(), isPushAndRemoveUntil: true);
      } else {
        buildSnackBar(context, res['message']);
      }

      setState(() => _loading = false);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          buildScaffold(
            context,
            _buildBody(),
          ),
          _loading ? buildLoading() : Container()
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child:  AppBar (
          elevation: 0,
          backgroundColor: Colors.white,
          // titleSpacing: -10.0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
              size: 35,
              color: FitwithColors.getSecondary300(),),
            padding: EdgeInsets.fromLTRB(20,20,0,0),
            onPressed: ()=> Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
          // padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: FitwithColors.getSecondary400(),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomOutlinedTextField(
                      labelText: '이름',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '\u26A0 이름을 입력해주세요';
                        }
                        _user['username'] = value.trim();
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 10.0),
                    CustomOutlinedTextField(
                      labelText: '이메일',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '\u26A0 이메일을 입력해주세요';
                        } else {
                          const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          final regExp = RegExp(pattern);
                          if (!regExp.hasMatch(value)) {
                            return '\u26A0 이메일 형식에 맞춰 작성해주세요';
                          }
                        }
                        _user['email'] = value.trim();
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        '* 이메일에 오타가 없는지 다시 한번 확인해주세요',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: FitwithColors.getSecondary300(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    CustomOutlinedTextField(
                      labelText: '비밀번호 입력',
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty)
                          return '\u26A0 비밀번호를 입력해주세요';
                        else {
                          const pattern =
                              r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,16}$';
                          final regExp = RegExp(pattern);
                          if (!regExp.hasMatch(value)) {
                            return '\u26A0 영문/숫자/특수문자 포함 8자 이상';
                          }
                        }
                        _password = value.trim();
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 10.0),
                    CustomOutlinedTextField(
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      validator: (String value) {
                        if (value != _password) return '\u26A0 비밀번호가 일치하지 않습니다';
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        '* 영문/숫자/특수문자 조합, 8자 이상',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: FitwithColors.getSecondary300(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    CustomCheckboxTile(
                      title: '개인정보 이용 동의',
                      value: _agreementPrivacy,
                      onChanged: (value) {
                        setState(() => _agreementPrivacy = value);
                      },
                    ),
                    CustomCheckboxTile(
                      title: '마케팅 활용 동의 (선택)',
                      value: _agreementMarketing,
                      onChanged: (value) {
                        setState(() => _agreementMarketing = value);
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                        child: Container(
                          width: _deviceSize.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: FitwithColors.getPrimaryColor(),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            if (_agreementPrivacy != true)
                              return buildSnackBar(
                                  context, '개인정보 이용 동의는 필수입니다.');
                            _user['password'] = sha512
                                .convert(utf8.encode(_password))
                                .toString();
                            CommonUtils.movePage(
                                context, SurveyPage(user: _user));
                          } else {
                            setState(() => _autoValidate = true);
                          }
                        }
                        // onTap: () async {
                        //   await _join();
                        // },
                        ),
                  ],
                ),
              ),
              SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '이미 회원이신가요?',
                        style: TextStyle(
                          color: FitwithColors.getSecondary300(),
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      InkWell(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: FitwithColors.getSecondary400(),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Text(
                      '약관보기',
                      style: TextStyle(
                        color: FitwithColors.getSecondary400(),
                        fontSize: 14.0,
                      ),
                    ),
                    onTap: () {
                      CommonUtils.movePage(context, SurveyPage());
                    },
                  )
                ],
              ),
              SizedBox(height: 5000.0),
            ],
          ),
        ),
      ),
    );
  }

  void _showSurvey() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '추가 정보 입력',
                style: TextStyle(
                  fontSize: 20.0,
                  color: FitwithColors.getSecondary400(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '* 트레이너님이 회원님을 알아볼 수 있도록',
                style: TextStyle(
                  fontSize: 12.0,
                  color: FitwithColors.getBasicOrange(),
                ),
              ),
              Text(
                '추가 정보를 입력해주세요',
                style: TextStyle(
                  fontSize: 12.0,
                  color: FitwithColors.getBasicOrange(),
                ),
              ),
              SizedBox(height: 40.0),
              InkWell(
                child: Container(
                  height: 80.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image != null
                          ? FileImage(_image)
                          : AssetImage('assets/cry_weet.png'),
                      fit: BoxFit.fitWidth,
                    ),
                    shape: BoxShape.circle,
                  ),
                  // child: _image == null
                  //     ? Icon(
                  //         Icons.person,
                  //         size: 80.0,
                  //         color: FitwithColors.getSecondary200(),
                  //       )
                  //     : Image.file(
                  //         _image,
                  //         fit: BoxFit.cover,
                  //       ),
                ),
                onTap: getImage,
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '성별',
                    style: TextStyle(
                      color: FitwithColors.getSecondary400(),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: FitwithColors.getPrimaryColor(),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            '남',
                            style: TextStyle(
                              color: FitwithColors.getPrimaryColor(),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: FitwithColors.getSecondary200(),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            '여',
                            style: TextStyle(
                              color: FitwithColors.getSecondary200(),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '나이',
                    style: TextStyle(
                      color: FitwithColors.getSecondary400(),
                    ),
                  ),
                  Container(
                    width: 90.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (text) {},
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FitwithColors.getSecondary200(),
                          ),
                        ),
                        isDense: true,
                        suffixIcon: Text(
                          '세',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: FitwithColors.getSecondary400(),
                            fontSize: 14.0,
                          ),
                        ),
                        suffixIconConstraints:
                            BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: FitwithColors.getSecondary200(),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: FitwithColors.getSecondary400(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: FitwithColors.getPrimaryColor(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
