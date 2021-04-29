import 'package:fitwith/api/api_beta.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/utils/utils_widget.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> _dropdownMenu = ['버그신고', '요구사항', '사용후기'];
  String _dropdownValue;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: [
          buildScaffold(
            context,
            _buildBody(),
            // appBar:  AppBar(
            //     elevation: 0.0,
            //     backgroundColor: FitwithColors.getPrimaryColor(),
            //     title: Text('글 작성하기'),
            //   ),
          ),
          _loading ? buildLoading() : Container()
        ],
      ),
    );
  }

  Widget _buildBody() {
    var _titleController = TextEditingController();
    var _contentController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar (
              titleSpacing: -10,
              title: Text('글 작성하기'),
              elevation: 0,
              // backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.chevron_left,
                  size: 35,
                  ),
                // padding: EdgeInsets.fromLTRB(5,20,0,0),
                onPressed: () {

                  Navigator.of(context).pop();
                }
              ),
            )
        ),
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                isDense: true,
                hint: Text('게시판을 선택해주세요.',
                style: TextStyle(
                  fontSize: 14
                ),),
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                  enabledBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(
                      color: FitwithColors.getSecondary200(),
                      // width: 1.0,
                    ),
                  ),
                ),
                value: _dropdownValue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: _dropdownMenu
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _dropdownValue = value),
              ),
              SizedBox(height: 10,),
              TextFormField(
                // maxLength: 20,
                validator: (_titleController) {
                  if (_titleController.isEmpty) {
                    return '* 제목은 필수 항목입니다';
                  }
                  return null;
                },
                controller: _titleController,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                          color: FitwithColors.getBasicOrange(), width: 2)),
                  disabledBorder: InputBorder.none,
                  border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(6.0),
                      borderSide:
                          BorderSide(color: FitwithColors.getSecondary200())),
                  focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(6.0),
                      borderSide:
                          BorderSide(color: FitwithColors.getPrimaryColor())),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: FitwithColors.getBasicOrange())),
                  contentPadding: EdgeInsets.all(10.0),
                  errorStyle: TextStyle(
                    color: FitwithColors.getBasicOrange(),
                    fontSize: 10,
                    height: 1.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: FitwithColors.getSecondary200(), width: 1.0),
                    // borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: '제목을 입력하세요 (필수)',
                  hintStyle: TextStyle(fontSize: 14, color: FitwithColors.getSecondary200())
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 15,
                controller: _contentController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(6.0),
                      borderSide:
                          BorderSide(color: FitwithColors.getPrimaryColor())),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: FitwithColors.getSecondary200(), width: 1.0),
                    // borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: '내용을 입력하세요',
                    hintStyle: TextStyle(fontSize: 14, color: FitwithColors.getSecondary200()),
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text('* 해당 게시물은 작성완료 후에는 수정이 불가하오니 내용을 다시 한 번 확인해 주시기 바랍니다.',
              style: TextStyle(
                fontSize: 13,
                color: FitwithColors.getBasicOrange()
              ),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      postBetaList(_titleController.text, _contentController.text, _dropdownValue);
                      print(_dropdownValue);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: 0.0,
                        left: 10.0,
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Align(
                        // alignment: Alignment.center,
                        child: WidgetUtils.batabuildDefaultButton(
                          '작성완료',
                              () {
                                postBetaList(_titleController.text, _contentController.text, _dropdownValue);
                            // func();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
