import 'package:fitwith/config/colors.dart';
import 'package:flutter/material.dart';

class CustomOutlinedTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final Function validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;

  CustomOutlinedTextField({
    Key key,
    this.labelText,
    this.obscureText = false,
    this.textInputAction,
    this.onEditingComplete,
    this.validator,
    this.keyboardType,
    this.controller,
    this.focusNode,
  }) : super(key: key);
  @override
  _CustomOutlinedTextFieldState createState() =>
      _CustomOutlinedTextFieldState();
}

class _CustomOutlinedTextFieldState extends State<CustomOutlinedTextField> {
  bool _isInvalid = false;
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          style: TextStyle(
            height: 1.5,
            color: FitwithColors.getSecondary300(),
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: FitwithColors.getSecondary200()),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: FitwithColors.getSecondary300()),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: FitwithColors.getBasicRed()),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: FitwithColors.getBasicRed()),
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: _isInvalid
                  ? FitwithColors.getBasicRed()
                  : FitwithColors.getSecondary300(),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorStyle: TextStyle(
              fontSize: 0.0,
              height: 0.0,
            ),
          ),
          keyboardType: widget.keyboardType,
          cursorColor: FitwithColors.getSecondary300(),
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          onEditingComplete: widget.onEditingComplete,
          validator: (value) {
            if (widget.validator(value) != null)
              setState(() {
                _errorMessage = widget.validator(value);
                _isInvalid = true;
              });
            else
              setState(() {
                _errorMessage = widget.validator(value);
                _isInvalid = false;
              });
            return widget.validator(value);
          },
          focusNode: widget.focusNode,
        ),
        _errorMessage != null
            ? Container(
                padding: EdgeInsets.only(left: 3.0, top: 3.0),
                child: Text(
                  _errorMessage ?? '',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: FitwithColors.getBasicRed(),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
