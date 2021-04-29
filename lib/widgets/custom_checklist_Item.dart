import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_checklist.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/widgets/custom_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class CustomChecklistItem extends StatefulWidget {
  final CheckList item;
  final int index;

  CustomChecklistItem({Key key, this.item, this.index}) : super(key: key);

  @override
  _CustomChecklistItemState createState() => _CustomChecklistItemState();
}

class _CustomChecklistItemState extends State<CustomChecklistItem> {
  final riveFileName = 'assets/flares/checkbox-linebold.riv';
  Artboard _artBoard;
  RiveAnimationController _controller;

  // loads a Rive file
  void _checkedAnimation() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      setState(() => _artBoard = file.mainArtboard
        ..addController(_controller = SimpleAnimation('checked')));
    }
  }

  void _uncheckedAnimation() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      setState(() => _artBoard = file.mainArtboard
        ..addController(_controller = SimpleAnimation('unchecked')));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('----------- premium_member_checklist_item build -----------');

    Color _color;
    Image _checkbox;

    if (widget.item.isEditable != null) {
      if (widget.item.isEditable) {
        _color = FitwithColors.getPrimaryColor();
        _checkbox = Image.asset('assets/flares/checked.png');
      } else {
        _color = FitwithColors.getSecondary300();
        _checkbox = Image.asset('assets/flares/unchecked.png');
      }
    }

    Widget _prefix;

    if (widget.item.time != null) {
      if (widget.item.time == 0) {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_morning.png',
              width: 28.0,
              color: widget.item.isEditable
                  ? FitwithColors.getPrimaryColor()
                  : FitwithColors.getSecondary300(),
            ),
            Text(
              '아침',
              style: TextStyle(
                fontSize: 12.0,
                color: widget.item.isEditable
                    ? FitwithColors.getPrimaryColor()
                    : FitwithColors.getSecondary300(),
              ),
            ),
          ],
        );
      } else if (widget.item.time == 1) {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_lunch.png',
              width: 25.0,
              color: widget.item.isEditable
                  ? FitwithColors.getPrimaryColor()
                  : FitwithColors.getSecondary300(),
            ),
            SizedBox(height: 4.0),
            Text(
              '점심',
              style: TextStyle(
                fontSize: 12.0,
                color: widget.item.isEditable
                    ? FitwithColors.getPrimaryColor()
                    : FitwithColors.getSecondary300(),
              ),
            ),
          ],
        );
      } else if (widget.item.time == 2) {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_dinner.png',
              width: 21.0,
              color: widget.item.isEditable
                  ? FitwithColors.getPrimaryColor()
                  : FitwithColors.getSecondary300(),
            ),
            SizedBox(height: 4.0),
            Text(
              '저녁',
              style: TextStyle(
                fontSize: 12.0,
                color: widget.item.isEditable
                    ? FitwithColors.getPrimaryColor()
                    : FitwithColors.getSecondary300(),
              ),
            ),
          ],
        );
      } else if (widget.item.time == 3) {
        _prefix = Column(
          children: [
            Image.asset(
              'assets/dietlist_snack.png',
              width: 24.0,
              color: widget.item.isEditable
                  ? FitwithColors.getPrimaryColor()
                  : FitwithColors.getSecondary300(),
            ),
            SizedBox(height: 4.0),
            Text(
              '간식',
              style: TextStyle(
                fontSize: 12.0,
                color: widget.item.isEditable
                    ? FitwithColors.getPrimaryColor()
                    : FitwithColors.getSecondary300(),
              ),
            ),
          ],
        );
      }
    }

    return Column(
      children: [
        widget.index == 0
            ? Container()
            : Divider(
                color: FitwithColors.getSecondary100(),
                height: 1.0,
              ),
        InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _prefix != null
                    ? Container(
                        width: 38.0,
                        child: _prefix,
                      )
                    : Container(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  widget.item.name,
                                  style: TextStyle(
                                    color: _color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.item.contents,
                                  style: TextStyle(color: _color, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _artBoard != null && (_controller?.isActive ?? false)
                              ? SizedBox(
                                  height: 25.0,
                                  width: 25.0,
                                  child: Rive(
                                    artboard: _artBoard,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(
                                  height: 25.0,
                                  width: 25.0,
                                  child: _checkbox,
                                ),
                          SizedBox(
                            height: 3.0,
                          ),
                              Text(
                                widget.item.checkDate != null
                                    ? '${DateFormat("Hm").format(widget.item.checkDate)}'
                                    : '',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: FitwithColors.getSecondary200()),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            if (widget.item.isEditable) {
              showDialog(
                context: context,
                builder: (context) => buildConfirmDialog(
                  context,
                  Center(
                    child: Text(
                      '정말 취소하시겠습니까?',
                      style: TextStyle(
                          color: FitwithColors.getPrimaryColor(),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '지금 취소하시면',
                            style: TextStyle(
                              fontSize: 14,
                              color: FitwithColors.getSecondary300(),
                            ),
                          ),
                          Text(
                            '체크한 시간이 변경될 수 있습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: FitwithColors.getSecondary300(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  () {
                    if (widget.item.time == null)
                      Provider.of<User>(context, listen: false)
                          .toggleWorkoutCheckbox(widget.index);
                    else
                      Provider.of<User>(context, listen: false)
                          .toggleDietCheckbox(widget.index);
                    // Provider.of<User>(context, listen: false)
                    //     .getPremiumUserData();
                    _uncheckedAnimation();
                  },
                ),
              );
            } else {
              if (widget.item.time == null)
                Provider.of<User>(context, listen: false)
                    .toggleWorkoutCheckbox(widget.index);
              else
                Provider.of<User>(context, listen: false)
                    .toggleDietCheckbox(widget.index);
              // Provider.of<User>(context, listen: false)
              //     .getPremiumUserData();
              _checkedAnimation();
            }
          },
        ),
      ],
    );
  }
}
