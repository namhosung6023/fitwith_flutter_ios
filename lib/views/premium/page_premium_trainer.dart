import 'package:date_format/date_format.dart';
import 'package:fitwith/providers/provider_trainer.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/premium/trainer/widget_trainer_selected_member.dart';
import 'package:flutter/material.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:fitwith/models/model_member.dart';
import 'package:provider/provider.dart';

class PremiumTrainerPage extends StatefulWidget {
  final BuildContext context;
  PremiumTrainerPage({Key key, this.context}) : super(key: key);

  @override
  _PremiumTrainerPageState createState() => _PremiumTrainerPageState();
}

class _PremiumTrainerPageState extends State<PremiumTrainerPage> {
  bool _loading = true;

  Future<void> _getMemberList() async {
    String _trainerId = Provider.of<User>(context, listen: false).trainerId;
    Provider.of<Trainer>(context, listen: false).trainerId = _trainerId;

    String _message =
        await Provider.of<Trainer>(context, listen: false).getMemberList();
    if (_message != null) buildSnackBar(widget.context, _message);
    setState(() => _loading = false);
  }

  @override
  void initState() {
    _getMemberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------- premium_trainer_page build -----------');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer<Trainer>(
        builder: (context, value, child) {
          return _loading
              ? buildLoading(color: Colors.white)
              : (value.memberList.length > 0)
                  ? ListView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      children: [
                        Text(
                          '회원 관리',
                          style: TextStyle(
                            color: FitwithColors.getSecondary600(),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('전체',
                              style: TextStyle(
                                  fontSize: 17
                              ),),
                            Text(' ${value.memberList.length}',
                              style: TextStyle(
                                  fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),),
                            Text('명',
                            style: TextStyle(
                              fontSize: 17
                            ),),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        ...value.memberList?.map(
                          (member) {
                            int index = value.memberList.indexOf(member);
                            return _buildMemberListItem(member, index);
                          },
                        ),
                      ],
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '회원 관리',
                              style: TextStyle(
                                  color: Color(0xff222224),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 60.0),
                          Image.asset(
                            'assets/cry_weet.png',
                            height: 90.0,
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            '수강중인 회원이 없습니다.',
                            style: TextStyle(
                              color: FitwithColors.getSecondary200(),
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextButton(
                            child: Text(
                              '강의 관리',
                              style: TextStyle(
                                color: FitwithColors.getPrimaryColor(),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 80.0),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(
                                  color: FitwithColors.getPrimaryColor(),
                                ),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  Widget _buildMemberListItem(Member member, int index) {
    final num _selectedTrainingDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .difference(member.startDate)
                .inDays +
            1;
    return Column(
      children: [
        index == 0
            ? Container()
            : Divider(
                color: FitwithColors.getSecondary100(),
                height: 20.0,
              ),
        InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                          child: member.avatar != '' &&  member.avatar != null ? Image.network(
                            member.avatar,
                            fit: BoxFit.cover,
                            width: 42.0,
                            height: 42.0,
                          ) : Image.asset("assets/Profile.png",
                            fit: BoxFit.cover,
                            width: 42.0,
                            height: 42.0,) ,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.username,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '(${member.gender == 'M' ? '남' : '여'}, ${member.age}세)',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: FitwithColors.getSecondary300(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_selectedTrainingDay일째',
                      style: TextStyle(
                        color: FitwithColors.getSecondary600(),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '(${formatDate(member.startDate, [
                        yy,
                        '.',
                        mm,
                        '.',
                        dd
                      ])} ~ ${formatDate(member.endDate, [
                        yy,
                        '.',
                        mm,
                        '.',
                        dd
                      ])})',
                      style: TextStyle(
                        color: FitwithColors.getSecondary200(),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Provider.of<Trainer>(context, listen: false).selectUser(
              member.premiumId,
              member.username,
              member.age,
              member.gender,
              _selectedTrainingDay,
            );
            Provider.of<Trainer>(context, listen: false).getPremiumUserData();
            CommonUtils.movePage(context, TrainerSelectedMember());
          },
        )
      ],
    );
  }
}
