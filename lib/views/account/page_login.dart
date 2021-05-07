import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fitwith/api/api_account.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/account/page_join.dart';
import 'package:fitwith/views/page_root.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_outlined_textfield.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_outlined_textfield.dart';

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _passwordFocusNode = FocusNode();

  Map<String, String> _user = {'email': '', 'password': ''};

  String _password = '';
  bool _autoValidate = false;
  bool _loading = false;
  Size _deviceSize;

  Future<void> _login() async {
    if (_formKey.currentState.validate()) {
      setState(() => _loading = true);
      _user['password'] = sha512.convert(utf8.encode(_password)).toString();
      Map<String, dynamic> res = await postLogin(_user);

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

    return Stack(
      children: [
        buildScaffold(
          context,
          _buildBody(),
          key: _scaffoldKey,
        ),
        _loading ? buildLoading() : Container()
      ],
    );
  }

  /// Build body
  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: 250.0,
                child: Image.asset(
                  'assets/logo_blue.png',
                  height: 40,
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '로그인',
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
                  children: [
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
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    CustomOutlinedTextField(
                      labelText: '비밀번호',
                      obscureText: true,
                      focusNode: _passwordFocusNode,
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
                      onEditingComplete: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await _login();
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      child: Container(
                        width: _deviceSize.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: FitwithColors.getPrimaryColor(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () async => await _login(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: FitwithColors.getSecondary300(),
                      ),
                    ),
                    onTap: () => CommonUtils.movePage(context, JoinPage()),
                  ),
                  // InkWell(
                  //     child: Text(
                  //   '비밀번호 찾기',
                  //   style: TextStyle(
                  //     fontSize: 14.0,
                  //     color: FitwithColors.getSecondary300(),
                  //   ),
                  // )),
                ],
              ),
              SizedBox(height: 40.0),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Card(
              //         elevation: 3.0,
              //         margin: EdgeInsets.zero,
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 15.0),
              //           height: 45.0,
              //           child: Row(
              //             children: [
              //               Container(
              //                 height: 20.0,
              //                 child: Image.asset('assets/ic_google.png'),
              //               ),
              //               Expanded(
              //                 child: Container(
              //                   alignment: Alignment.center,
              //                   child: Text(
              //                     'Google 로그인',
              //                     style: TextStyle(
              //                       fontSize: 14.0,
              //                       fontWeight: FontWeight.bold,
              //                       color: FitwithColors.getPrimaryColor(),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10.0),
              //     Expanded(
              //       flex: 1,
              //       child: Card(
              //         elevation: 3.0,
              //         margin: EdgeInsets.zero,
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 15.0),
              //           height: 45.0,
              //           child: Row(
              //             children: [
              //               Container(
              //                 height: 18.0,
              //                 child: Image.asset('assets/ic_naver.png'),
              //               ),
              //               Expanded(
              //                 child: Container(
              //                   alignment: Alignment.center,
              //                   child: Text(
              //                     'Naver 로그인',
              //                     style: TextStyle(
              //                       fontSize: 14.0,
              //                       fontWeight: FontWeight.bold,
              //                       color: FitwithColors.getPrimaryColor(),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  /// 소셜로그인 버튼 위젯 생성
  Widget _buildSocialLoginButton(String type, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Image.asset('assets/ic_$type.png'),
      ),
    );
  }

  /// 소셜 로그인
  /// fixme :: 소셜 로그인 처리
  // void _socialLogin(String type) {
  //   if (type == _TYPE_GOOGLE) {
  //     print('나는 구글!');
  //   } else {
  //     print('나는 네이버!');
  //   }
  // }
}
