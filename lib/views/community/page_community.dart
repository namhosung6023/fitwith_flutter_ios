import 'package:fitwith/api/api_beta.dart';
import 'package:fitwith/models/model_beta.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/community/page_View_Details.dart';
import 'package:fitwith/views/community/page_write.dart';
import 'package:fitwith/widgets/custom_confirm_dialog.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fitwith/config/colors.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _formKey = GlobalKey<FormState>();
  Size _deviceSize;
  bool _loading = true;
  List _listItem = [];
  // String type = ;

  Future<void> _getBetaList() async {
    print(_dropdownValue);
    _listItem = await getBetaList(_dropdownValue);

    setState(() => _loading = false);
  }
  List<String> _dropdownMenu = ['전체', '버그신고', '요구사항', '사용후기'];
  String _dropdownValue = '전체';

  @override
  void initState() {
    super.initState();
    _getBetaList();
    print(_dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? buildLoading(color: Colors.white)
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('커뮤니티', style: TextStyle(
                        fontSize: 16,
                        color: FitwithColors.getSecondary300(),
                        fontWeight: FontWeight.bold
                      ),),
                      Container(
                        child: InkWell(
                          onTap: () => CommonUtils.movePage(context, WritePage()),
                          child: Row(
                            children: [
                              Image.asset('assets/communitypost.png',
                                height: 17,
                                // color: FitwithColors.getPrimaryColor(),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                '글 작성하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: FitwithColors.getPrimaryColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  // itemHeight: 100,
                    // isExpanded: false,
                  isDense: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(
                        color: FitwithColors.getSecondary200(),
                        width: 1.0,
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
                  onChanged: (value) {
                    setState(() => _dropdownValue = value);
                    _getBetaList();
                  }
                ),
                SizedBox(height: 20.0),
                Expanded(
                        child: ListView(
                          children: [
                            ..._listItem
                                .map((item) => _buildCommunityCard(item))
                                .toList(),
                          ],
                        ),
                      ),
                // _Drpdown(_listItem),
                // Expanded(
                //    child: ListView(
                //      children: [
                //      ..._listItem
                //            .map((item) => _buildCommunityCard(item))
                //            .toList(),
                //      ],
                //    ),
                //  ),
                // _buildCommunityCard(),
              ],
            ),
          );
  }

  Widget _buildCommunityCard(dynamic item) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    // print(item.userId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () =>
              CommonUtils.movePage(context, CommunityDetailPage(item: item)),
          child: Column(

            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 18.0,  color: FitwithColors.getSecondary500()),
                    ),
                    SizedBox(height: 6.0),
                    Text(
                      item.contents,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        color: FitwithColors.getSecondary300(),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      children: [
                       if(item.type != null) Text(
                          item.type,
                          style: TextStyle(
                            color: FitwithColors.getPrimaryColor(),
                          ),
                        ),
                        Container(
                          height: 14.0,
                          child: VerticalDivider(
                            color: FitwithColors.getSecondary300(),
                            width: 15.0,
                          ),
                        ),
                        Text(item.username,
                          style: TextStyle(
                            color: FitwithColors.getSecondary250()
                        ),),
                        Container(
                          height: 14.0,
                          child: VerticalDivider(
                            color: FitwithColors.getSecondary300(),
                            width: 15.0,
                          ),
                        ),
                        Text(
                          '${timeago.format(item.createdAt, locale: 'ko')}',
                          style: TextStyle(
                            color: FitwithColors.getSecondary250()
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 10.0),
        Divider(
          height: 34.0,
          color: FitwithColors.getSecondary200(),
        ),
      ],
    );
  }

  Widget _buildDialog(Beta item) {
    var _titleController = TextEditingController();
    var _contentController = TextEditingController();
    _titleController.text = item.title;
    _contentController.text = item.contents;
    final int maxLength = 20;
    bool _editable = true;
    _deviceSize = MediaQuery.of(context).size;
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
                TextField(
                  controller: _titleController,
                  enabled: _editable,
                  maxLength: maxLength,
                  maxLines: _editable ? 1 : null,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: FitwithColors.getPrimaryColor())),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            BorderSide(color: FitwithColors.getPrimaryColor())),
                    contentPadding: EdgeInsets.all(10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
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
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                '확인',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: FitwithColors.getSecondary200(),
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     InkWell(
                          //       onTap: () {
                          //         showDialog(
                          //           context: context,
                          //           builder: (context) => buildConfirmDialog(
                          //             context,
                          //             Center(
                          //               child: Text(
                          //                 '정말 삭제하시겠습니까?',
                          //                 style: TextStyle(
                          //                     color: FitwithColors
                          //                         .getPrimaryColor(),
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //             Container(
                          //               height: 40.0,
                          //               child: Center(
                          //                 child: Column(
                          //                   children: [
                          //                     Text(
                          //                       '삭제하신 후에는 복구가 어려우니',
                          //                       style: TextStyle(
                          //                         fontSize: 13,
                          //                         color: FitwithColors
                          //                             .getSecondary300(),
                          //                       ),
                          //                     ),
                          //                     Text(
                          //                       '다시한번 확인해주시기 바랍니다.',
                          //                       style: TextStyle(
                          //                         fontSize: 13,
                          //                         color: FitwithColors
                          //                             .getSecondary300(),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //                 () {
                          //               if (index != null) {
                          //                 Provider.of<Trainer>(context,
                          //                     listen: false)
                          //                     .deleteWorkoutList(item.outerId,
                          //                     item.innerId, index);
                          //               } else {
                          //                 Provider.of<Trainer>(context,
                          //                     listen: false)
                          //                     .updateDietList(
                          //                     '', '', item.time);
                          //               }
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         );
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(5.0),
                          //         child: Text(
                          //           '삭제',
                          //           style: TextStyle(
                          //             fontSize: 16.0,
                          //             color: FitwithColors.getBasicOrange(),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 5.0),
                          //     InkWell(
                          //       onTap: () {
                          //         if (_formKey.currentState.validate()) {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //               SnackBar(content: Text('저장됨')));
                          //         }
                          //         print('index');
                          //         print(index);
                          //         if (index == null) {
                          //           Provider.of<Trainer>(context, listen: false)
                          //               .addWorkoutList(
                          //             _titleController.text,
                          //             _contentController.text,
                          //             false,
                          //           );
                          //         } else {
                          //           if (item.time == null) {
                          //             Provider.of<Trainer>(context,
                          //                 listen: false)
                          //                 .updateWorkoutList(
                          //               index,
                          //               _titleController.text,
                          //               _contentController.text,
                          //             );
                          //           } else {
                          //             print(item.name == '');
                          //             // if (item.name == '') {
                          //             //   Provider.of<Trainer>(context, listen: false)
                          //             //       .addDietList(_titleController.text,
                          //             //       _contentController.text, index);
                          //             // } else
                          //             //
                          //             //
                          //             // {
                          //             Provider.of<Trainer>(context,
                          //                 listen: false)
                          //                 .updateDietList(_titleController.text,
                          //                 _contentController.text, index);
                          //             // }
                          //           }
                          //         }
                          //         if (_titleController.text != '')
                          //           Navigator.of(context).pop();
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.only(
                          //           right: 0.0,
                          //           left: 10.0,
                          //           top: 5.0,
                          //           bottom: 5.0,
                          //         ),
                          //         child: Text(
                          //           '완료',
                          //           style: TextStyle(
                          //             fontSize: 16.0,
                          //             color: FitwithColors.getPrimaryColor(),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
}
