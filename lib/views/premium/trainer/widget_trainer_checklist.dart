import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_checklist.dart';
import 'package:fitwith/providers/provider_trainer.dart';
import 'package:fitwith/utils/utils_widget.dart';
import 'package:fitwith/widgets/custom_confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrainerChecklist extends StatefulWidget {
  @override
  _TrainerChecklistState createState() => _TrainerChecklistState();
}

class _TrainerChecklistState extends State<TrainerChecklist> {
  final _formKey = GlobalKey<FormState>();
  Size _deviceSize;
  double _itemHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    print('----------- premium_trainer_checklist widget build -----------');

    _deviceSize = MediaQuery.of(context).size;
    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0.0);

    return Consumer<Trainer>(
      builder: (context, value, child) {
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                '운동',
                style: TextStyle(
                  color: FitwithColors.getSecondary400(),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // ReorderableListView 높이 + Divider 높이
              height: value.workoutList.length * _itemHeight +
                  value.workoutList.length * 2.0,
              child: NotificationListener<OverscrollNotification>(
                onNotification: (OverscrollNotification value) {
                  if (value.overscroll < 0 &&
                      _scrollController.offset + value.overscroll <= 0) {
                    if (_scrollController.offset != 0)
                      _scrollController.jumpTo(0);
                    return true;
                  }
                  if (_scrollController.offset + value.overscroll >=
                      _scrollController.position.maxScrollExtent) {
                    if (_scrollController.offset !=
                        _scrollController.position.maxScrollExtent)
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    return true;
                  }
                  _scrollController
                      .jumpTo(_scrollController.offset + value.overscroll);
                  return true;
                },
                child: ReorderableListView(
                  physics: ClampingScrollPhysics(),
                  buildDefaultDragHandles: false,
                  children: [
                    for (int index = 0;
                        index < value.workoutList.length;
                        index++)
                      _buildWorkoutItem(value.workoutList[index], index),
                  ],
                  onReorder: (int oldIndex, int newIndex) =>
                      value.reorderWorkoutList(oldIndex, newIndex),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  // minimumSize: Size(350.0, 28.0),
                  backgroundColor: FitwithColors.getSecondary50(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(
                      color: FitwithColors.getPrimaryColor(),
                    ),
                  ),
                ),
                child: Text(
                  '+ 추가 ',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: FitwithColors.getPrimaryColor(),
                  ),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => _buildDialog(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: Text(
                '식단',
                style: TextStyle(
                  color: FitwithColors.getSecondary400(),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUploadButton(value.dietList[0], '아침', 0),
                  _buildUploadButton(value.dietList[1], '점심', 1),
                  _buildUploadButton(value.dietList[2], '저녁', 2),
                  _buildUploadButton(value.dietList[3], '간식', 3),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  value.dietList[0].name == ''
                      ? Container()
                      : value.dietList[0].isEditable
                          ? _buildFoodItem(value.dietList[0], '아침')
                          : InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildDialog(
                                    item: value.dietList[0], index: 0),
                              ),
                              child: _buildFoodItem(value.dietList[0], '아침'),
                            ),
                  value.dietList[1].name == ''
                      ? Container()
                      : value.dietList[1].isEditable
                          ? _buildFoodItem(value.dietList[1], '점심')
                          : InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildDialog(
                                    item: value.dietList[1], index: 1),
                              ),
                              child: _buildFoodItem(value.dietList[1], '점심'),
                            ),
                  value.dietList[2].name == ''
                      ? Container()
                      : value.dietList[2].isEditable
                          ? _buildFoodItem(value.dietList[2], '저녁')
                          : InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildDialog(
                                    item: value.dietList[2], index: 2),
                              ),
                              child: _buildFoodItem(value.dietList[2], '저녁'),
                            ),
                  value.dietList[3].name == ''
                      ? Container()
                      : value.dietList[3].isEditable != null &&
                              value.dietList[3].isEditable
                          ? _buildFoodItem(value.dietList[3], '간식')
                          : InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildDialog(
                                    item: value.dietList[3], index: 3),
                              ),
                              child: _buildFoodItem(value.dietList[3], '간식'),
                            ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
          ],
        );
      },
    );
  }

  Widget _buildUploadButton(CheckList diet, String title, int time) {
    var _color = diet.name == ''
        ? FitwithColors.getSecondary200()
        : FitwithColors.getPrimaryColor();
    return Container(
      width: _deviceSize.width / 5,
      height: _deviceSize.width / 12,
      child: OutlinedButton(
        onPressed: () {
          if (diet.isEditable != true)
            showDialog(
              context: context,
              builder: (context) => _buildDialog(item: diet, index: time),
            );
        },
        child: Text(
          title,
          style: TextStyle(color: _color, fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.1),
          ),
          side: BorderSide(color: _color, width: 1.0),
        ),
      ),
    );
  }

  Widget _buildFoodItem(CheckList dietList, String title) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    var _color = dietList.isEditable != null && dietList.isEditable
        ? FitwithColors.getPrimaryColor()
        : FitwithColors.getSecondary300();

    Widget _prefix;

    if (dietList.time != null) {
      if (title == '아침') {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_morning.png',
              width: 28.0,
              color: _color,
            ),
            Text(
              '아침',
              style: TextStyle(
                fontSize: 12.0,
                color: _color,
              ),
            ),
          ],
        );
      } else if (title == '점심') {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_lunch.png',
              width: 25.0,
              color: _color,
            ),
            SizedBox(height: 4.0),
            Text(
              '점심',
              style: TextStyle(
                fontSize: 12.0,
                color: _color,
              ),
            ),
          ],
        );
      } else if (title == '저녁') {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_dinner.png',
              width: 21.0,
              color: _color,
            ),
            SizedBox(height: 4.0),
            Text(
              '저녁',
              style: TextStyle(
                fontSize: 12.0,
                color: _color,
              ),
            ),
          ],
        );
      } else if (title == '간식') {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_snack.png',
              width: 24.0,
              color: _color,
            ),
            SizedBox(height: 4.0),
            Text(
              '간식',
              style: TextStyle(
                fontSize: 12.0,
                color: _color,
              ),
            ),
          ],
        );
      }
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _prefix,
              SizedBox(width: 24.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dietList.name,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              color: _color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        dietList.isEditable != null && dietList.isEditable
                            ? Container(
                                padding: EdgeInsets.all(4.0),
                                child: Image.asset('assets/checkIcon.png'),
                              )
                            : Container(),
                        SizedBox(width: 4.0),
                        Text(
                          dietList.isEditable != null &&
                                  dietList.isEditable &&
                                  dietList.checkDate != null
                              ? '${timeago.format(dietList.checkDate, locale: 'ko')}'
                              : '',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: FitwithColors.getPrimaryColor(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        dietList.contents,
                        style: TextStyle(
                          color: _color,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          indent: 10.0,
          endIndent: 10.0,
          height: 2.0,
          color: title == '간식'
              ? Colors.transparent
              : FitwithColors.getSecondary200(),
        ),
      ],
    );
  }

  Widget _buildWorkoutItem(CheckList item, int index) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    Color _color = item.isEditable != null && item.isEditable
        ? FitwithColors.getPrimaryColor()
        : FitwithColors.getSecondary300();
    return Column(
      key: Key('$index'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          indent: 10.0,
          endIndent: 5.0,
          height: 1.0,
          color:
              index == 0 ? Colors.transparent : FitwithColors.getSecondary200(),
        ),
        InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (context) => _buildDialog(item: item, index: index),
          ),
          child: Container(
            height: _itemHeight,
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: _color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    item.isEditable != null && item.isEditable
                        ? Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.0),
                                child: Image.asset('assets/checkIcon.png'),
                              ),
                              SizedBox(width: 1.0),
                              Text(
                                item.checkDate != null
                                    ? '${timeago.format(item.checkDate, locale: 'ko')}'
                                    : '',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: FitwithColors.getPrimaryColor(),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.contents,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: _color,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 15,),
                      Container(
                        // padding: EdgeInsets.only(left: 8.0),
                        // height: 80.0,
                        // alignment: Alignment.bottomLeft,
                        child: ReorderableDragStartListener(
                          index: index,
                          child: Image.asset(
                            "assets/change2.png",
                            color: FitwithColors.getSecondary200(),
                            width: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDialog({CheckList item, int index}) {
    final int maxLength = 20;
    var _titleController = TextEditingController();
    var _contentController = TextEditingController();
    bool _editable = true;
    if (item != null) {
      if (item.isEditable) {
        _editable = false;
      }
    }
    _deviceSize = MediaQuery.of(context).size;
    if (item != null) {
      _titleController.text = item.name;
      _contentController.text = item.contents;
    } else {
      _titleController.text = '';
      _contentController.text = '';
    }
    return AlertDialog(
      contentPadding:
          EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0, bottom: 15.0),
      buttonPadding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: Builder(
        builder: (context) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  enabled: _editable,
                  maxLength: maxLength,
                  maxLines: _editable ? 1 : null,
                  validator: (_titleController) {
                    if (_titleController.isEmpty) {
                      return '* 제목은 필수 항목입니다';
                    }
                    return null;
                  },
                  controller: _titleController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    counterText: "",
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                            color: FitwithColors.getBasicOrange(), width: 2)),
                    // disabledBorder: InputBorder.none,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: FitwithColors.getPrimaryColor())),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: FitwithColors.getPrimaryColor())),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FitwithColors.getBasicOrange())),
                    // contentPadding: EdgeInsets.only(
                    //   left: 5,
                    //   right: 0,
                    //   top: 10,
                    //   bottom: 10,
                    // ),
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(
                      color: FitwithColors.getBasicOrange(),
                      fontSize: 10,
                      height: 1.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    hintText: '제목을 입력하세요 (필수)',

                    // isDense: true,
                  ),
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 12),
                _editable
                    ? TextField(
                        maxLines: 5,
                        controller: _contentController,
                        style: TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                  color: FitwithColors.getPrimaryColor())),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          hintText: '내용을 입력하세요',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(maxHeight: 300.0),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: SingleChildScrollView(
                          child: Text(_contentController.text),
                        ),
                      ),
                SizedBox(height: 18.0),
                _editable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 10.0,
                                left: 0.0,
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: FitwithColors.getSecondary200(),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => buildConfirmDialog(
                                      context,
                                      Center(
                                        child: Text(
                                          '정말 삭제하시겠습니까?',
                                          style: TextStyle(
                                              color: FitwithColors
                                                  .getPrimaryColor(),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        height: 40.0,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                '삭제하신 후에는 복구가 어려우니',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: FitwithColors
                                                      .getSecondary300(),
                                                ),
                                              ),
                                              Text(
                                                '다시한번 확인해주시기 바랍니다.',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: FitwithColors
                                                      .getSecondary300(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      () {
                                        if (index != null) {
                                          Provider.of<Trainer>(context,
                                                  listen: false)
                                              .deleteWorkoutList(item.outerId,
                                                  item.innerId, index);
                                        } else {
                                          Provider.of<Trainer>(context,
                                                  listen: false)
                                              .updateDietList(
                                                  '', '', item.time);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: FitwithColors.getBasicOrange(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('저장됨')));
                                  }
                                  print('index');
                                  print(index);
                                  if (index == null) {
                                    Provider.of<Trainer>(context, listen: false)
                                        .addWorkoutList(
                                      _titleController.text,
                                      _contentController.text,
                                      false,
                                    );
                                  } else {
                                    if (item.time == null) {
                                      Provider.of<Trainer>(context,
                                              listen: false)
                                          .updateWorkoutList(
                                        index,
                                        _titleController.text,
                                        _contentController.text,
                                      );
                                    } else {
                                      print(item.name == '');
                                      // if (item.name == '') {
                                      //   Provider.of<Trainer>(context, listen: false)
                                      //       .addDietList(_titleController.text,
                                      //       _contentController.text, index);
                                      // } else
                                      //
                                      //
                                      // {
                                      Provider.of<Trainer>(context,
                                              listen: false)
                                          .updateDietList(_titleController.text,
                                              _contentController.text, index);
                                      // }
                                    }
                                  }
                                  if (_titleController.text != '')
                                    Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    right: 0.0,
                                    left: 10.0,
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  child: Text(
                                    '완료',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: FitwithColors.getPrimaryColor(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 0.0,
                                left: 10.0,
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: FitwithColors.getPrimaryColor(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _confirmDialog(String checklistId, String workoutId, int index) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 40),
      contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 20),
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
            Provider.of<Trainer>(context, listen: false)
                .deleteWorkoutList(checklistId, workoutId, index);
            Navigator.pop(context);
          }),
        ),
      ],
    );
  }
}
