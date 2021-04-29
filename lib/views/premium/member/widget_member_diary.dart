import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/utils/utils_widget.dart';
import 'package:fitwith/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MemberDiary extends StatefulWidget {
  final BuildContext context;
  MemberDiary({Key key, this.context}) : super(key: key);
  @override
  _MemberDiaryState createState() => _MemberDiaryState();
}

class _MemberDiaryState extends State<MemberDiary> {
  Size _deviceSize;
  File _image;
  final file = ImagePicker();

  Future _galleryImage(String imageName) async {
    final pickedFile = await file.getImage(source: ImageSource.gallery);
    _cropImage(pickedFile.path, imageName);
  }

  Future _cameraImage(String imageName) async {
    final pickedFile = await file.getImage(source: ImageSource.camera);
    _cropImage(pickedFile.path, imageName);
  }

  Future _cropImage(String filePath, String imageName) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    setState(() {
      if (croppedImage != null) {
        _image = File(croppedImage.path);
        print(_image);

        Provider.of<User>(context, listen: false)
            .postUploadImage(_image, imageName);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('----------- premium_member_diary widget build -----------');

    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool _isScroll = Provider.of<User>(context, listen: false).isScroll;
      if (_isScroll)
        _scrollController.animateTo(0.0,
            duration: Duration(milliseconds: 600), curve: Curves.ease);
      Provider.of<User>(context, listen: false).isScroll = false;
    });

    _deviceSize = MediaQuery.of(context).size;

    return Consumer<User>(builder: (context, user, child) {
      print(user.bodyLog.morningFoodTitle);
      return ListView(
        controller: _scrollController,
        children: [
          SizedBox(height: 10.0),
          _buildTitle('체중 관리'),
          SizedBox(height: 20.0),
          _buildSubtitle(
            '공복 사진',
            true,
            imageName: 'morningBody',
            length: 1,
          ),
          _buildComment('아침 배변 후 몸 사진을 찍어주세요'),
          SizedBox(height: 10.0),
          _buildWeight(
            'morningWeight',
            user.bodyLog.morningWeight,
          ),
          _buildImages(
            user.bodyLog.morningBody,
            'morningBody',
          ),
          SizedBox(height: 20.0),
          _buildSubtitle(
            '자기 전 사진',
            true,
            imageName: 'nightBody',
            length: 1,
          ),
          _buildComment('잠들기 직전 몸 사진을 찍어주세요'),
          SizedBox(height: 10.0),
          _buildWeight(
            'nightWeight',
            user.bodyLog.nightWeight,
          ),
          _buildImages(
            user.bodyLog.nightBody,
            'nightBody',
          ),
          SizedBox(height: 50.0),
          _buildTitle('식단 관리'),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              '사진 업로드',
              style: TextStyle(
                color: FitwithColors.getSecondary300(),
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(height: 3.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildUploadButton(
                  '아침',
                  user.bodyLog.morningFood.length,
                  'morningFood',
                ),
                _buildUploadButton(
                  '점심',
                  user.bodyLog.afternoonFood.length,
                  'afternoonFood',
                ),
                _buildUploadButton(
                  '저녁',
                  user.bodyLog.nightFood.length,
                  'nightFood',
                ),
                _buildUploadButton(
                  '간식',
                  user.bodyLog.snack.length,
                  'snack',
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Column(
            children: [
              _buildSubtitle(
                '아침',
                false,
                length: user.bodyLog.morningFood.length,
              ),
              _buildImages(
                user.bodyLog.morningFood,
                'morningFood',
              ),
              CustomTextField(
                title: user.bodyLog.morningFoodTitle,
                foodName: 'morningFoodTitle',
                length: user.bodyLog.morningFood.length,
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Column(
            children: [
              _buildSubtitle(
                '점심',
                false,
                length: user.bodyLog.afternoonFood.length,
              ),
              _buildImages(user.bodyLog.afternoonFood, 'afternoonFood'),
              CustomTextField(
                title: user.bodyLog.afternoonFoodTitle,
                foodName: 'afternoonFoodTitle',
                length: user.bodyLog.afternoonFood.length,
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Column(
            children: [
              _buildSubtitle(
                '저녁',
                false,
                length: user.bodyLog.nightFood.length,
              ),
              _buildImages(user.bodyLog.nightFood, 'nightFood'),
              Container(
                child: CustomTextField(
                  title: user.bodyLog.nightFoodTitle,
                  foodName: 'nightFoodTitle',
                  length: user.bodyLog.nightFood.length,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubtitle(
                '간식',
                false,
                length: user.bodyLog.snack.length,
              ),
              _buildImages(user.bodyLog.snack, 'snack'),
              CustomTextField(
                title: user.bodyLog.snackTitle,
                foodName: 'snackTitle',
                length: user.bodyLog.snack.length,
              ),
            ],
          ),
          SizedBox(height: 40.0),
        ],
      );
    });
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: FitwithColors.getPrimaryColor(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(
    String value,
    bool isImageUpload, {
    String imageName,
    int length,
  }) {
    return length != null && length > 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: FitwithColors.getSecondary300(),
                  ),
                ),
                isImageUpload
                    ? SizedBox(
                        height: 30.0,
                        child: TextButton(
                          onPressed: () => _showModalBottomSheet(imageName),
                          child: Text(
                            '사진 업로드',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: FitwithColors.getSecondary200(),
                            padding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 15.0,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        : Container();
  }

  Widget _buildComment(String comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        comment,
        style: TextStyle(
          fontSize: 12.0,
          color: FitwithColors.getBasicOrange(),
        ),
      ),
    );
  }

  Widget _buildWeight(String weightName, double weight) {
    TextEditingController _textController = TextEditingController();
    if(weight != null) _textController.text = '$weight';
    _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
      child: Row(
        children: [
          Text(
            '몸무게',
            style: TextStyle(
              fontSize: 14.0,
              color: FitwithColors.getSecondary300(),
            ),
          ),
          SizedBox(width: 12.0),
          SizedBox(
            width: 100.0,
            child: TextField(
              controller: _textController,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              onSubmitted: (text) {
                Provider.of<User>(context, listen: false).postUploadWeight(
                  text,
                  weightName,
                );
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: FitwithColors.getSecondary200(),
                  ),
                ),
                isDense: true,
                suffixIcon: Text(
                  'kg',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: FitwithColors.getSecondary400(),
                    fontSize: 14.0,
                  ),
                ),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                hintText: '0.0',
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
          ),
        ],
      ),
    );
  }

  Widget _buildImages(List images, String imageName) {
    return images.length > 0
        ? CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              enableInfiniteScroll: false,
            ),
            items: images.map<Widget>((imageUrl) {
              return Builder(builder: (BuildContext context) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 4.0,
                        left: 4.0,
                      ),
                      width: _deviceSize.width,
                      child: InkWell(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                        onTap: () => _showImageDialog(imageUrl),
                      ),
                    ),
                    Positioned(
                      right: 12.0,
                      top: 18.0,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () =>
                            _showAlertDialog(context, imageUrl, imageName),
                      ),
                    ),
                  ],
                );
              });
            }).toList(),
          )
        : Container();
  }

  void _showImageDialog(String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: _deviceSize.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(imageUrl, fit: BoxFit.fill),
                  ),
                ),
                Positioned(
                  right: 18.0,
                  top: 18.0,
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _show() {

  }
  void _showAlertDialog(
      BuildContext context, String imageUrl, String imageName) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 40),
          contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          actionsPadding: EdgeInsets.fromLTRB(30, 0, 30, 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          title: Center(
            child: Text("정말 삭제하겠습니까?",
                style: TextStyle(
                    color: FitwithColors.getPrimaryColor(),
                    fontWeight: FontWeight.bold)),
          ),
          content: SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                child: Column(
                  children: [
                    Text(
                      '삭제하신 후 에는 복구가 어렵습니다.',
                      style: TextStyle(
                        fontSize: 13,
                        color: FitwithColors.getSecondary300(),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '확인 후 삭제 부탁드립니다.',
                      style: TextStyle(
                        fontSize: 13,
                        color: FitwithColors.getSecondary300(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: WidgetUtils.buildDefaultButton2(
                '취소',
                    () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: WidgetUtils.buildDefaultButton1('확인', () {
                Provider.of<User>(context, listen: false)
                    .postDeleteImage(imageUrl, imageName);
                Navigator.pop(context);
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadButton(String value, int length, String imageName) {
    return Container(
      width: _deviceSize.width / 5,
      child: OutlinedButton(
        onPressed: () => _showModalBottomSheet(imageName),
        child: Text(
          value,
          style: TextStyle(
            color: length > 0
                ? FitwithColors.getPrimaryColor()
                : FitwithColors.getSecondary200(),
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.1),
          ),
          side: BorderSide(
            color: length > 0
                ? FitwithColors.getPrimaryColor()
                : FitwithColors.getSecondary200(),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Future<void> _showModalBottomSheet(String imageName) {
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: ((builder) => _bottomSheet(imageName)),
    );
  }

  Widget _bottomSheet(String imageName) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: _deviceSize.width / 2,
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
                _cameraImage(imageName);
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            width: _deviceSize.width / 2,
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
                _galleryImage(imageName);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
