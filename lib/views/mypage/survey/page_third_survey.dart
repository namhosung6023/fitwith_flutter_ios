import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/config/env.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/page_root.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdSurveyPage extends StatefulWidget {
  final List<String> field;
  final String etcField;
  final String address;
  final String detailAddress;
  ThirdSurveyPage({
    Key key,
    this.field,
    this.etcField,
    this.address,
    this.detailAddress,
  }) : super(key: key);
  @override
  _ThirdSurveyPageState createState() => _ThirdSurveyPageState();
}

class _ThirdSurveyPageState extends State<ThirdSurveyPage> {
  String _photoUrl = '';
  String _mobileNo = '';
  TextEditingController _trainerIntro = TextEditingController();

  convert(TextEditingValue oldValue, TextEditingValue newValue) {
    print("OldValue: ${oldValue.text}, NewValue: ${newValue.text}");
    String newText = newValue.text;
    if (newText.length == 11) {
      // The below code gives a range error if not 10.
      RegExp phone = RegExp(r'(\d{3})(\d{4})(\d{4})');
      var matches = phone.allMatches(newValue.text);
      var match = matches.elementAt(0);
      newText = '${match.group(1)}-${match.group(2)}-${match.group(3)}';
    }
    // TODO limit text to the length of a formatted phone number?
    setState(() {
      _mobileNo = newText;
    });
    return TextEditingValue(
      text: newText,
      selection: TextSelection(
          baseOffset: newValue.text.length, extentOffset: newValue.text.length),
    );
  }

  final file = ImagePicker();

  Future _galleryImage() async {
    final pickedFile = await file.getImage(source: ImageSource.gallery);
    _cropImage(pickedFile.path);
  }

  Future _cameraImage() async {
    final pickedFile = await file.getImage(source: ImageSource.camera);
    _cropImage(pickedFile.path);
  }

  Future _cropImage(String filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    String fileName = croppedImage.path.split('/').last;
    String mimeType = mime(fileName);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    Dio dio;
    BaseOptions options = dioOptions;
    dio = Dio(options);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    dio.options.headers['accesstoken'] = _token;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(croppedImage.path,
          filename: fileName, contentType: MediaType(mimee, type)),
    });
    try {
      Response response = await dio.post('file/upload/avatar', data: formData);
      if (response.data['photoUrl'] != null) {
        setState(() {
          _photoUrl = response.data['photoUrl'];
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

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
                  '님의 추가 정보를',
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
              '입력해주세요',
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '트레이너 등록을 위한 필수 입력사항입니다',
              style: TextStyle(
                color: FitwithColors.getSecondary300(),
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '휴대폰 번호',
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => convert(oldValue, newValue),
                ),
              ],
              keyboardType: TextInputType.phone,
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
                labelText: '010-1234-5678',
                labelStyle: TextStyle(
                  color: FitwithColors.getSecondary200(),
                  fontSize: 16.0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '프로필 이미지 업로드',
                  style: TextStyle(
                    color: FitwithColors.getSecondary300(),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showModalBottomSheet();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 30.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: FitwithColors.getSecondary200(),
                    ),
                    child: Text(
                      '업로드',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            _photoUrl == ''
                ? Container()
                : Container(
                    height: 180.0,
                    child: Image.network(_photoUrl, fit: BoxFit.cover),
                  ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '트레이너 소개',
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              controller: _trainerIntro,
              maxLines: 15,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: FitwithColors.getPrimaryColor(),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: FitwithColors.getSecondary200(),
                    width: 1.0,
                  ),
                  // borderRadius: BorderRadius.circular(6.0),
                ),
                hintText: '내용을 입력하세요',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: FitwithColors.getSecondary200(),
                ),
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(6.0),
                    ),
              ),
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
                      '완료',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () async {
                    Dio dio;
                    BaseOptions options = dioOptions;
                    dio = Dio(options);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String _token = prefs.getString('token');
                    dio.options.headers['accesstoken'] = _token;
                    try {
                      Response response =
                          await dio.post('trainer/register', data: {
                        "mobileNo": _mobileNo,
                        "address": widget.address,
                        "mainFields": widget.field,
                        "etcField": widget.etcField,
                        "profileImages": _photoUrl,
                        "trainerIntro": _trainerIntro.text,
                      });
                      print(response.data);
                    } on DioError catch (e) {
                      print(e.message);
                    }
                    CommonUtils.movePage(
                      context,
                      RootPage(),
                      isPushAndRemoveUntil: true,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Future<void> _showModalBottomSheet() {
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: ((builder) => _bottomSheet()),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: FitwithColors.getPrimaryColor(),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0)),
            ),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Camera',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
              onTap: () {
                _cameraImage();
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: FitwithColors.getPrimaryColor(),
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                _galleryImage();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
