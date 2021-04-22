import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_bodylog.dart';
import 'package:fitwith/providers/provider_trainer.dart';
import 'package:fitwith/widgets/custom_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainerDiary extends StatefulWidget {
  @override
  _TrainerDiaryState createState() => _TrainerDiaryState();
}

class _TrainerDiaryState extends State<TrainerDiary> {
  Size _deviceSize;

  @override
  Widget build(BuildContext context) {
    print('----------- premium_trainer_diary widget build -----------');

    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0.0);

    _deviceSize = MediaQuery.of(context).size;
    return Consumer<Trainer>(builder: (context, value, child) {
      BodyLog _bodyLog = value.bodyLog;
      return value.bodyLog.id != ''
          ? ListView(
              controller: _scrollController,
              children: [
                SizedBox(height: 10.0),
                _buildTitle('체중 관리'),
                SizedBox(height: 20.0),
                _bodyLog.morningBody.length > 0 ||
                        _bodyLog.morningWeight != null
                    ? _buildSubtitle('공복사진')
                    : Container(),
                SizedBox(height: 5.0),
                _bodyLog.morningWeight != null
                    ? _buildWeight(_bodyLog.morningWeight)
                    : Container(),
                _bodyLog.morningBody.length > 0
                    ? _buildImages(_bodyLog.morningBody)
                    : Container(),
                SizedBox(height: 25.0),
                _bodyLog.nightBody.length > 0 || _bodyLog.nightWeight != null
                    ? _buildSubtitle('자기전 사진')
                    : Container(),
                SizedBox(height: 5.0),
                _bodyLog.nightWeight != null
                    ? _buildWeight(_bodyLog.nightWeight)
                    : Container(),
                _bodyLog.nightBody.length > 0
                    ? _buildImages(_bodyLog.nightBody)
                    : Container(),
                SizedBox(height: 50.0),
                _buildTitle('식단 관리'),
                SizedBox(height: 20.0),
                _bodyLog.morningFood.length > 0
                    ? _buildSubtitle('아침')
                    : Container(),
                _bodyLog.morningFood.length > 0
                    ? _buildImages(_bodyLog.morningFood)
                    : Container(),
                _bodyLog.morningFoodTitle != ''
                    ? _buildFoodTitle(
                        _bodyLog.morningFoodTitle, 'morningFoodTitle')
                    : Container(),
                SizedBox(height: 10.0),
                _bodyLog.afternoonFood.length > 0
                    ? _buildSubtitle('점심')
                    : Container(),
                _bodyLog.afternoonFood.length > 0
                    ? _buildImages(_bodyLog.afternoonFood)
                    : Container(),
                _bodyLog.afternoonFoodTitle != ''
                    ? _buildFoodTitle(
                        _bodyLog.afternoonFoodTitle, 'afternoonFoodTitle')
                    : Container(),
                SizedBox(height: 10.0),
                _bodyLog.nightFood.length > 0
                    ? _buildSubtitle('저녁')
                    : Container(),
                _bodyLog.nightFood.length > 0
                    ? _buildImages(_bodyLog.nightFood)
                    : Container(),
                _bodyLog.nightFoodTitle != ''
                    ? _buildFoodTitle(_bodyLog.nightFoodTitle, 'nightFoodTitle')
                    : Container(),
                SizedBox(height: 10.0),
                _bodyLog.snack.length > 0 ? _buildSubtitle('간식') : Container(),
                _bodyLog.snack.length > 0
                    ? _buildImages(_bodyLog.snack)
                    : Container(),
                _bodyLog.snackTitle != ''
                    ? _buildFoodTitle(_bodyLog.snackTitle, 'snackTitle')
                    : Container(),
                const SizedBox(height: 16.0),
              ],
            )
          : Center(
              child: SingleChildScrollView(
                child: buildBlankPage('업로드된 데이터가 없습니다.'),
              ),
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
                    // color: FitwithColors.getPrimaryColor(),
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

  Widget _buildSubtitle(String value) {
    return Container(
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
        ],
      ),
    );
  }

  Widget _buildImages(List images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        enableInfiniteScroll: false,
      ),
      items: images
          .map<Widget>(
            (imageUrl) => Container(
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
          )
          .toList(),
    );
  }

  Widget _buildFoodTitle(String title, String foodName) {
    String _iconPath;
    switch (foodName) {
      case 'morningFoodTitle':
        _iconPath = 'assets/dietlist_morning.png';
        break;
      case 'afternoonFoodTitle':
        _iconPath = 'assets/dietlist_lunch.png';
        break;
      case 'nightFoodTitle':
        _iconPath = 'assets/dietlist_dinner.png';
        break;
      case 'snackTitle':
        _iconPath = 'assets/dietlist_snack.png';
        break;
      default:
        print('food icon not found');
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                _iconPath,
                width: 24.0,
                height: 24.0,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    right: _deviceSize.width * 0.04 + 5.0,
                    top: 3.0,
                  ),
                  child: Text(
                    title,
                    maxLines: null,
                    style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
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

  Widget _buildWeight(num value) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 5.0,
        left: 30.0,
        right: 30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '몸무게 기록',
            style: TextStyle(
              color: FitwithColors.getSecondary200(),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 13.0),
          Expanded(
            child: Text(
              '$value kg',
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
