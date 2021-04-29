import 'package:fitwith/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final String foodName;
  final int length;

  CustomTextField({Key key, this.title, this.foodName, this.length})
      : super(key: key);
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _textController = TextEditingController();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) {
      Provider.of<User>(context, listen: false)
          .setFoodTitle(_textController.text, widget.foodName);
      Provider.of<User>(context, listen: false)
          .postUploadFoodTitle(widget.foodName);
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.title;
    _textController.selection =
        TextSelection.fromPosition(TextPosition(offset: widget.title.length));
    String _iconPath;
    switch (widget.foodName) {
      case 'morningFoodTitle':
        _iconPath = 'assets/dietlist_morning.png';
        break;
      case 'afternoonFoodTitle':
        _iconPath = 'assets/dietlist_lunch.png';
        break;
      case 'nightFoodTitle':
        _iconPath = 'assets/dietlist_dinner.png';
        break;
      case 'snackTitle':
        _iconPath = 'assets/dietlist_snack.png';
        break;
      default:
        print('food icon not found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.length != null && widget.length > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10.0, top: 8.0),
                          child: Image.asset(
                            _iconPath,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            focusNode: _focus,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: FitwithColors.getSecondary400(),
                            ),
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ),
                        widget.title != ''
                            ? Container(
                          padding: EdgeInsets.only( top: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<User>(context, listen: false)
                                        .setFoodTitle('', widget.foodName);
                                    Provider.of<User>(context, listen: false)
                                        .postUploadFoodTitle(widget.foodName);
                                    return _textController.clear;
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 20.0,
                                    color: FitwithColors.getSecondary200(),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
