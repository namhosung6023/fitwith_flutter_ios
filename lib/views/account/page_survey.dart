import 'dart:io';

import 'package:fitwith/api/api_account.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/page_root.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyPage extends StatefulWidget {
  final Map<String, String> user;
  SurveyPage({Key key, this.user}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  bool _loading = false;
  TextEditingController _textController = TextEditingController();

  Map<String, String> _user;
  String _gender;
  String _photoUrl;

  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
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
    setState(() => _loading = true);

    Map<String, dynamic> res = await postJoin(_user);

    if (res['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', res['accesstoken']);
      CommonUtils.movePage(context, RootPage(), isPushAndRemoveUntil: true);
    } else {
      buildSnackBar(context, res['message']);
    }

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    print(_user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildScaffold(
          context,
          _buildBody(),
        ),
        _loading ? buildLoading() : Container()
      ],
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar (
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
              size: 35,
              color: FitwithColors.getSecondary300(),),
            padding: EdgeInsets.fromLTRB(20,20,0,0),
            onPressed: ()=> Navigator.of(context).pop(),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '추가 정보 입력',
                style: TextStyle(
                  fontSize: 24.0,
                  color: FitwithColors.getSecondary400(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                '* 트레이너님이 회원님을 알아볼 수 있도록',
                style: TextStyle(
                  fontSize: 14.0,
                  color: FitwithColors.getBasicOrange(),
                ),
              ),
              SizedBox(height: 3.0),
              Text(
                '추가 정보를 입력해주세요',
                style: TextStyle(
                  fontSize: 14.0,
                  color: FitwithColors.getBasicOrange(),
                ),
              ),
              SizedBox(height: 60.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                   _getImage();
                  });
                },
                child: ClipOval(

                  // borderRadius: BorderRadius.all(Radius.circular(50)),
                   // child : Image.asset('assets/joinProfile.png',width: 140),
                  // radius: 800,
                  // onTap: _getImage,
                  // highlightColor: Colors.transparent,
                  // splashColor: Colors.transparent,
                  child:  _image != null
                            ? Image.file(_image, height: 140, width: 140, fit: BoxFit.cover,)
                            : Image.asset('assets/joinProfile.png',width: 140, height: 140, fit: BoxFit.cover,),
                  ),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '성별',
                    style: TextStyle(
                      fontSize: 16,
                      color: FitwithColors.getSecondary400(),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _gender != '남'
                                  ? FitwithColors.getSecondary200()
                                  : FitwithColors.getPrimaryColor(),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            '남',
                            style: TextStyle(
                              color: _gender != '남'
                                  ? FitwithColors.getSecondary200()
                                  : FitwithColors.getPrimaryColor(),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => setState(() => _gender = '남'),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _gender != '여'
                                  ? FitwithColors.getSecondary200()
                                  : FitwithColors.getPrimaryColor(),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            '여',
                            style: TextStyle(
                              color: _gender != '여'
                                  ? FitwithColors.getSecondary200()
                                  : FitwithColors.getPrimaryColor(),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => setState(() => _gender = '여'),
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
                      fontSize: 16,
                      color: FitwithColors.getSecondary400(),
                    ),
                  ),
                  Container(
                    width: 90.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _textController,
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
                            fontSize: 16.0,
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
              SizedBox(height: 70.0),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15.0),
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
                onTap: () async {
                  if (_gender == null ||
                      _textController.text == null ||
                      _textController.text == '')
                    buildSnackBar(context, '성별과 나이는 필수입니다.');
                  else {
                    if(_image != null) _photoUrl = await Provider.of<User>(context, listen: false)
                        .postUploadAvatar(_image);
                    _user['gender'] = _gender;
                    _user['age'] = _textController.text;
                    _user['avatar'] = _photoUrl;
                    print(_user.toString());
                    await _join();
                  }
                },
              ),
              SizedBox(height: 400.0),
            ],
          ),
        ),
      ),
    );
  }
}
