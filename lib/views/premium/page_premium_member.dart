import 'package:fitwith/providers/provider_page_index.dart';
import 'package:fitwith/widgets/custom_blank_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/views/premium/member/widget_member_checklist.dart';
import 'package:fitwith/views/premium/member/widget_member_diary.dart';
import 'package:fitwith/widgets/custom_date_timeline.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class PremiumMemberPage extends StatefulWidget {
  final BuildContext context;
  PremiumMemberPage({Key key, this.context}) : super(key: key);
  @override
  _PremiumMemberPageState createState() => _PremiumMemberPageState();
}

class _PremiumMemberPageState extends State<PremiumMemberPage>
    with TickerProviderStateMixin {
  final _calendarCtrl = CalendarController();
  TabController _tabCtrl;
  bool _loading = true;
  String _myTrainerId = '';

  Future<void> _getPremiumUserData() async {
    String _message =
        await Provider.of<User>(context, listen: false).getPremiumUserData();
    if (_message != null) buildSnackBar(widget.context, _message);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _tabCtrl = TabController(vsync: this, length: 2);
    _myTrainerId = Provider.of<User>(context, listen: false).myTrainerId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _getPremiumUserData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------- premium_member_page build -----------');

    return _myTrainerId != ''
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDatePicker(),
                    _buildTodayButton(),
                  ],
                ),
              ),
              DateTimeLine(
                onDateChange: (date) {
                  Provider.of<User>(context, listen: false).isScroll = true;
                  Provider.of<User>(context, listen: false)
                      .getPremiumUserData(date: date);
                },
                selectedDay:
                    Provider.of<User>(context, listen: false).selectedDay,
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: _loading
                    ? buildLoading(color: Colors.white)
                    : Column(
                        children: [
                          _buildTrainerComment(),
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              controller: this._tabCtrl,
                              children: [
                                MemberChecklist(),
                                MemberDiary(context: widget.context),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildBlankPage('함께 하고싶은 트레이너를 선택해주세요'),
                SizedBox(height: 40.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: FitwithColors.getPrimaryColor(),
                    ),
                    child: Text(
                      '신청하러 가기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<PageIndex>(context, listen: false).index = 2;
                  },
                )
              ],
            ),
          );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildCalendarDialog(context));
      },
      child: Container(
        height: 30.0,
        width: 160.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.0,
              color: FitwithColors.getSecondary300(),
            ),
            SizedBox(width: 6.0),
            Center(
              child: Consumer<User>(
                builder: (context, user, child) {
                  return Text(
                    '${DateFormat('yyyy.MM.dd').format(user.selectedDay)}',
                    style: TextStyle(color: FitwithColors.getSecondary300()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayButton() {
    return InkWell(
      onTap: () async {
        Provider.of<User>(context, listen: false).isScroll = true;
        String message = await Provider.of<User>(context, listen: false)
            .getPremiumUserData(date: DateTime.now());
        if (message != null) buildSnackBar(widget.context, message);
      },
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        height: 23.0,
        width: 56.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: FitwithColors.getSecondary300(),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
            child: Text(
          'TODAY',
          style: TextStyle(
            fontSize: 11.0,
            color: FitwithColors.getSecondary300(),
          ),
        )),
      ),
    );
  }

  Widget _buildTrainerComment() {
    return Consumer<User>(
      builder: (context, user, child) {
        timeago.setLocaleMessages('ko', timeago.KoMessages());
        print(user.trainerProfile);
        return user.trainerComment != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      dense: true,
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 10.0),
                        title: Row(
                          children: [
                            ClipOval(
                              child: user.trainerProfile != null
                                  ? Image.network(
                                      user.trainerProfile,
                                      fit: BoxFit.cover,
                                      height: 30.0,
                                      width: 30.0,
                                    )
                                  : Container(),
                            ),
                            SizedBox(width: 10.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  user.trainerName,
                                  style: TextStyle(
                                    color: FitwithColors.getSecondary400(),
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(width: 3.0),
                                Text(
                                  'Wither',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12.0,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  '${timeago.format(user.trainerComment.createdAt, locale: 'ko')}',
                                  style: TextStyle(
                                    color: FitwithColors.getSecondary200(),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 12.0,
                                right: 20.0,
                                bottom: 14.0,
                                top: 4.0),
                            child: Text(
                              user.trainerComment.comment,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                height: 1.3,
                                color: FitwithColors.getSecondary300(),
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildTabBar() {
    final border = Container(
      height: 1.0,
      color: FitwithColors.getSecondary100(),
    );
    final tabBar = TabBar(
      controller: this._tabCtrl,
      labelColor: FitwithColors.getPrimaryColor(),
      unselectedLabelColor: FitwithColors.getSecondary200(),
      labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      tabs: [
        Tab(text: '체크리스트'),
        Tab(text: '관리 일지'),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          Positioned(left: 0.0, right: 0.0, bottom: 0.0, child: border),
          Container(
            height: 40.0,
            child: tabBar,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TableCalendar(
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                titleTextBuilder: (date, _) =>
                    DateFormat('yyyy년 MM월').format(date),
              ),
              initialSelectedDay:
                  Provider.of<User>(context, listen: false).selectedDay,
              calendarController: this._calendarCtrl,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarStyle:
                  const CalendarStyle(selectedColor: Color(0xff4781ec)),
              onDaySelected: (DateTime day, List events, List holidays) {
                Provider.of<User>(context, listen: false).isScroll = true;
                Provider.of<User>(context, listen: false)
                    .getPremiumUserData(date: day);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
