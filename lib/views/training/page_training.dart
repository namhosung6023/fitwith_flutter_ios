import 'package:date_format/date_format.dart';
import 'package:fitwith/api/api_trainer.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_trainer_card.dart';
import 'package:fitwith/providers/provider_page_index.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/widgets/custom_confirm_dialog.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool _loading = true;

  List _trainers;

  TrainerCard _myTrainer;

  String _myTrainerId;

  void _getTrainerList() async {
    Map<String, dynamic> res = await getTrainerList();

    _myTrainerId = Provider.of<User>(context, listen: false).myTrainerId;

    if (res['data'] != null) {
      _trainers = [];
      for (int i = 0; i < res['data'].length; i++) {
        List<String> _fields = [];
        if (res['data'][i]['trainer']['mainFields'] != null) {
          for (int j = 0;
              j < res['data'][i]['trainer']['mainFields'].length;
              j++) {
            String _field = res['data'][i]['trainer']['mainFields'][j];
            _fields.add(_field);
          }
        }
        if (res['data'][i]['trainer']['etcField'] != null &&
            res['data'][i]['trainer']['etcField'] != '') {
          _fields.add(res['data'][i]['trainer']['etcField']);
        }
        TrainerCard _trainer = TrainerCard(
          res['data'][i]['trainer']['_id'],
          res['data'][i]['username'],
          res['data'][i]['trainer']['profileImages'][0],
          _fields,
        );
        if (_myTrainerId == res['data'][i]['trainer']['_id'])
          setState(() => _myTrainer = _trainer);
        else
          _trainers.add(_trainer);
      }
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    if(Provider.of<User>(context, listen: false).type == '1') {
      Provider.of<User>(context, listen: false).getPremiumUserData();
      _getTrainerList();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? buildLoading(color: Colors.white)
        : Consumer<User>(builder: (context, user, child) {
            print('here');
            print(user.premiumId);
            return user.type == '1' ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                children: [
                  Text(
                    '트레이너',
                    style: TextStyle(
                      color: FitwithColors.getSecondary400(),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  user.myTrainerId == ''
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '내 트레이너',
                              style: TextStyle(
                                fontSize: 16,
                                color: FitwithColors.getSecondary400(),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            _myTrainer != null
                                ? _itemBuilder(_myTrainer, user)
                                : Container(),
                            SizedBox(height: 30.0),
                          ],
                        ),
                  Row(
                    children: [
                      Text(
                        '추천 트레이너',
                        style: TextStyle(
                          color: FitwithColors.getSecondary400(),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '(${_trainers.length}명)',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: FitwithColors.getSecondary300(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ..._trainers
                      .map((value) => _itemBuilder(value, user))
                      .toList(),
                ],
              ),
            )
            : Container(
              child: Center(
                child: Image.asset('assets/comingsoon_5.png',height: 350,)
              ),
            );
          });
  }

  Widget _itemBuilder(TrainerCard value, User user) {
    final num _trainingDays =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .difference(user.startDate ?? DateTime.now())
                .inDays +
            1;
    return Container(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Card(
        child: InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        value.profileImage,
                        fit: BoxFit.cover,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value.username,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: FitwithColors.getSecondary400(),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Wither',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: FitwithColors.getBasicOrange(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5.0),
                        value.trainerId == _myTrainerId
                            ? Text(
                                "${formatDate(user.startDate, [
                                  yy,
                                  '.',
                                  mm,
                                  '.',
                                  dd
                                ])} - ${formatDate(user.endDate, [
                                  yy,
                                  '.',
                                  mm,
                                  '.',
                                  dd
                                ])}",
                                style: TextStyle(
                                  color: FitwithColors.getSecondary200(),
                                  fontSize: 13.0,
                                ),
                              )
                            : Row(
                                children: [
                                  ...value.field.map<Widget>((String value) {
                                    return Text(
                                      '#$value ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: FitwithColors.getSecondary200(),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
                value.trainerId == _myTrainerId
                    ? Text(
                        '$_trainingDays일째',
                        style: TextStyle(
                          color: FitwithColors.getSecondary600(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          onTap: () {
            if (_myTrainerId == value.trainerId) {
              Provider.of<PageIndex>(context, listen: false).index = 0;
            } else {
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
                              '"${value.username}"',
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
                        SizedBox(height: 3,),
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
                    String message =
                        await user.postApplyPremium(value.trainerId);
                    _getTrainerList();
                    print(message);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
