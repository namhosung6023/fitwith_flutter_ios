import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/widgets/custom_blank_page.dart';
import 'package:fitwith/widgets/custom_checklist_Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberChecklist extends StatefulWidget {
  @override
  _MemberChecklistState createState() => _MemberChecklistState();
}

class _MemberChecklistState extends State<MemberChecklist> {
  @override
  Widget build(BuildContext context) {
    print('----------- premium_member_checklist_page build -----------');

    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool _isScroll = Provider.of<User>(context, listen: false).isScroll;
      if (_isScroll && _scrollController.hasClients)
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 600),
          curve: Curves.ease,
        );
      Provider.of<User>(context, listen: false).isScroll = false;
    });

    return Consumer<User>(
      builder: (context, user, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: (user.workoutList.length > 0 || user.dietList.length > 0)
              ? ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  children: [
                    user.workoutList.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Text(
                                '운동',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: FitwithColors.getSecondary400(),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              ...user.workoutList?.map(
                                (workout) {
                                  int _index =
                                      user.workoutList.indexOf(workout);
                                  return CustomChecklistItem(
                                    index: _index,
                                    item: workout,
                                  );
                                },
                              ),
                              SizedBox(height: 20.0),
                            ],
                          )
                        : Container(),
                    user.dietList.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Text(
                                '식단',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: FitwithColors.getSecondary400(),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              ...user.dietList?.map(
                                (diet) {
                                  print(diet.name);
                                  int _index = user.dietList.indexOf(diet);
                                  return diet.name != ''
                                      ? CustomChecklistItem(
                                          index: _index,
                                          item: diet,
                                        )
                                      : Container();
                                },
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 20.0),
                  ],
                )
              : buildBlankPage('작성된 체크리스트가 없습니다.'),
        );
      },
    );
  }
}
