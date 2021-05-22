import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_trainer_card.dart';
import 'package:fitwith/providers/provider_page_index.dart';
import 'package:fitwith/widgets/custom_confirm_dialog.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainerDetailPage extends StatefulWidget {
  final TrainerCard trainer;
  TrainerDetailPage({Key key, @required this.trainer}) : super(key: key);
  @override
  _TrainerDetailPageState createState() => _TrainerDetailPageState();
}

class _TrainerDetailPageState extends State<TrainerDetailPage> {
  bool _loading = true;

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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.trainer.profileImage),
            SizedBox(height: 15.0),
            Text(
              'Premium Wither',
              style: TextStyle(
                color: FitwithColors.getBasicOrange(),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              widget.trainer.username,
              style: TextStyle(
                color: FitwithColors.getSecondary400(),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: widget.trainer.field
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: 10.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: FitwithColors.getSecondary100(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(e),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20.0),
            Divider(),
            SizedBox(height: 10.0),
            Text(
              '트레이너 소개',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FitwithColors.getSecondary400(),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              widget.trainer.trainerIntro ?? '',
              style: TextStyle(
                fontSize: 16,
                color: FitwithColors.getSecondary400(),
              ),
            ),
            SizedBox(height: 30.0),
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
                  '프리미엄 관리 신청',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => buildConfirmDialog(
                    context,
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '"${widget.trainer.username}"',
                                style: TextStyle(
                                  color: FitwithColors.getPrimaryColor(),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '님께',
                                style: TextStyle(
                                  color: FitwithColors.getSecondary400(),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            '신청하시겠습니까?',
                            style: TextStyle(
                              color: FitwithColors.getSecondary400(),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40.0,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '신청 후 변경이 불가하오니',
                              style: TextStyle(
                                fontSize: 13,
                                color: FitwithColors.getSecondary300(),
                              ),
                            ),
                            Text(
                              '다시 한번 확인해주세요',
                              style: TextStyle(
                                fontSize: 13,
                                color: FitwithColors.getSecondary300(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    () async {
                      // String message =
                      //     await user.postApplyPremium(value.trainerId);
                      // _getTrainerList();
                      // print(message);
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
