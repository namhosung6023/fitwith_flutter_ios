import 'package:fitwith/api/api_beta.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/community/page_write.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fitwith/config/colors.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool _loading = true;
  List _listItem = [];

  Future<void> _getBetaList() async {
    _listItem = await getBetaList();
    setState(() => _loading = false);
  }

  List<String> _dropdownMenu = ['전체', '버그신고', '요구사항', '사용후기'];
  String _dropdownValue = '전체';

  @override
  void initState() {
    super.initState();
    _getBetaList();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('게시판'),
                    InkWell(
                      onTap: () => CommonUtils.movePage(context, WritePage()),
                      child: Row(
                        children: [
                          Icon(
                            Icons.create,
                            color: FitwithColors.getPrimaryColor(),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '글 작성하기',
                            style: TextStyle(
                              color: FitwithColors.getPrimaryColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField(
                  isDense: true,
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
                  onChanged: (value) => setState(() => _dropdownValue = value),
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

                // _buildCommunityCard(),
              ],
            ),
          );
  }

  Widget _buildCommunityCard(dynamic item) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    print(item.userId);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Text(
                item.contents,
                maxLines: 2,
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    item.type,
                    style: TextStyle(
                      color: FitwithColors.getPrimaryColor(),
                    ),
                  ),
                  Container(
                    height: 20.0,
                    child: VerticalDivider(
                      color: FitwithColors.getSecondary300(),
                      width: 25.0,
                    ),
                  ),
                  Text(item.username),
                  Container(
                    height: 20.0,
                    child: VerticalDivider(
                      color: FitwithColors.getSecondary300(),
                      width: 25.0,
                    ),
                  ),
                  Text(
                    '${timeago.format(item.createdAt, locale: 'ko')}',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Divider(
          height: 20.0,
          color: FitwithColors.getSecondary200(),
        ),
      ],
    );
  }
}
