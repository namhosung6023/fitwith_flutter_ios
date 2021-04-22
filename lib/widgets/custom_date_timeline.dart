import 'package:fitwith/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateChangeListener = void Function(DateTime selectedDate);

class DateTimeLine extends StatefulWidget {
  final DateChangeListener onDateChange;
  final DateTime selectedDay;
  DateTimeLine({this.onDateChange, this.selectedDay});
  @override
  _DateTimeLineState createState() => _DateTimeLineState();
}

class _DateTimeLineState extends State<DateTimeLine> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final double _height = 55.0;
    final double _width = 55.0;
    final DateTime _startDate = widget.selectedDay.subtract(Duration(days: 30));
    double _deviceWidth = MediaQuery.of(context).size.width;

    ScrollController _controller =
        ScrollController(initialScrollOffset: _width * 30.5 - _deviceWidth / 2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double _position = _width * (30.5) - _deviceWidth / 2;
      _controller.animateTo(
        _position,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });

    return Container(
      height: _height,
      child: ListView.builder(
        itemCount: 61,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          DateTime date;
          DateTime _date = _startDate.add(Duration(days: index));
          date = new DateTime(_date.year, _date.month, _date.day);

          _currentDate = widget.selectedDay;

          bool isSelected =
              _currentDate != null ? _compareDate(date, _currentDate) : false;

          return InkWell(
            child: Container(
              width: _width,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected
                        ? FitwithColors.getPrimaryColor()
                        : Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? FitwithColors.getPrimaryColor()
                            : FitwithColors.getSecondary300()),
                  ),
                  Text(
                    DateFormat("E").format(date).toUpperCase(),
                    style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? FitwithColors.getPrimaryColor()
                            : FitwithColors.getSecondary300()),
                  )
                ],
              ),
            ),
            onTap: () {
              // _controller.animateTo(_width * (index + 0.5) - _deviceWidth / 2,
              //     duration: Duration(milliseconds: 400), curve: Curves.ease);
              widget.onDateChange(date);
              setState(() {
                _currentDate = date;
              });
            },
          );
        },
      ),
    );
  }

  bool _compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
