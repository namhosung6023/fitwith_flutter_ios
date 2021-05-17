import 'package:fitwith/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CustomCheckboxInput extends StatefulWidget {
  final String title;
  final bool value;
  final Function onChanged;

  CustomCheckboxInput({Key key, this.title, this.value, this.onChanged})
      : super(key: key);

  @override
  _CustomCheckboxInputState createState() => _CustomCheckboxInputState();
}

class _CustomCheckboxInputState extends State<CustomCheckboxInput> {
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
    Image _checkbox;
    bool _value;
    if (widget.value)
      _checkbox = Image.asset('assets/flares/checked.png');
    else
      _checkbox = Image.asset('assets/flares/unchecked.png');

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            _artBoard != null
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
            SizedBox(width: 15.0),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: widget.title,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (widget.value) {
          setState(() => _value = false);
          _uncheckedAnimation();
        } else {
          setState(() => _value = true);
          _checkedAnimation();
        }
        widget.onChanged(_value);
      },
    );
  }
}
