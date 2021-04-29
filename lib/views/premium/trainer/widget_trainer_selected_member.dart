import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_trainer.dart';
import 'package:fitwith/views/premium/trainer/widget_trainer_checklist.dart';
import 'package:fitwith/views/premium/trainer/widget_trainer_diary.dart';
import 'package:fitwith/widgets/custom_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainerSelectedMember extends StatefulWidget {
  @override
  _TrainerSelectedMemberState createState() => _TrainerSelectedMemberState();
}

class _TrainerSelectedMemberState extends State<TrainerSelectedMember>
    with SingleTickerProviderStateMixin {
  final _commentController = TextEditingController();
  final _calendarCtrl = CalendarController();
  TabController _tabCtrl;
  Size _deviceSize;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    print(
        '----------- premium_trainer_selected_member widget build -----------');
    _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          titleSpacing: -5.0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 35,),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Consumer<Trainer>(builder: (context, value, child) {
            String _name = value.selectedUsername;
            String _gender = value.selectedUserGender;
            int _age = value.selectedUserAge;
            int _days = value.selectedUserTrainingDays;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  _name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' (${_gender == 'M' ? '남' : '여'}, $_age)',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                Text(
                  '  |  $_days일째',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
          backgroundColor: FitwithColors.getPrimaryColor(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0),
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
            onDateChange: (date) async {
              Provider.of<Trainer>(context, listen: false)
                  .getPremiumUserData(date: date);
            },
            selectedDay: Provider.of<Trainer>(context).selectedDay,
          ),
          SizedBox(height: 8.0),
          _buildComment(),
          SizedBox(height: 5.0),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: this._tabCtrl,
              children: [
                TrainerChecklist(),
                TrainerDiary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildCalendarDialog(context),
        );
      },
      child: Container(
        height: 30.0,
        width: 160.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 17.0,
              color: FitwithColors.getSecondary300(),
            ),
            SizedBox(width: 6.0),
            Center(
              child: Consumer<Trainer>(
                builder: (context, value, child) {
                  return Text(
                    '${DateFormat('yyyy.MM.dd').format(value.selectedDay)}',
                    style: TextStyle(color: FitwithColors.getSecondary300(), fontSize: 16),
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
        Provider.of<Trainer>(context, listen: false)
            .getPremiumUserData(date: DateTime.now());
      },
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        height: 25.0,
        width: 60.0,
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
            fontSize: 13.0,
            color: FitwithColors.getSecondary300(),
          ),
        )),
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
                  Provider.of<Trainer>(context, listen: false).selectedDay,
              calendarController: this._calendarCtrl,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarStyle:
                  const CalendarStyle(selectedColor: Color(0xff4781ec)),
              onDaySelected: (DateTime day, List events, List holidays) {
                Provider.of<Trainer>(context, listen: false)
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

  Widget _buildComment() {
    return Consumer<Trainer>(
      builder: (context, value, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _commentController.text = value.trainerComment.comment;
          _commentController.selection = TextSelection.fromPosition(
              TextPosition(offset: _commentController.text.length));
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 5.0,
              ),
              child: Text(
                '오늘의 한마디',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: _deviceSize.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => _showModalBottomSheet(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 15.0,
                    ),
                    child: Text(
                      value.trainerComment.comment == ''
                          ? '내용을 입력하세요'
                          : value.trainerComment.comment,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: value.trainerComment.comment == ''
                            ? FitwithColors.getSecondary200()
                            : FitwithColors.getSecondary400(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      elevation: 14.0,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 15.0,
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 12.0,
                    color: FitwithColors.getSecondary400(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _commentController,
                  // focusNode: _commentFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _commentController.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '지우기',
                      style: TextStyle(
                        color: FitwithColors.getSecondary300(),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('저장'),
                ),
              ],
            ),
          ],
        );
      },
    ).whenComplete(
      () {
        Provider.of<Trainer>(context, listen: false)
            .setTrainerComment(_commentController.text);
        Provider.of<Trainer>(context, listen: false).postTrainerComment();
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
      labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
}
