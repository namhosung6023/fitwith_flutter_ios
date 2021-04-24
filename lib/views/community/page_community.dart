import 'package:flutter/material.dart';

import 'package:fitwith/config/colors.dart';

import '../../config/colors.dart';
import '../../config/colors.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String dropdownValue = '사용 후기';

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onTap: () {
                  print('글작성');
                },
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
              prefixIcon: Icon(
                Icons.comment,
                color: FitwithColors.getSecondary200(),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: FitwithColors.getSecondary200(),
                  width: 1.0,
                ),
              ),
            ),
            value: dropdownValue,
            icon: Icon(Icons.keyboard_arrow_down),
            items: ['사용 후기']
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) => setState(() => dropdownValue = value),
          ),
          SizedBox(height: 20.0),
          _buildCommunityCard(),
        ],
      ),
    );
  }

  Widget _buildCommunityCard() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '한 달만에 5kg 뺐어요~! 식단 공개 합니다!',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Text(
                '제가 저번 달에 갑자기 살이 찌는 바람에 다이어트를 결심하게 되었습니다. 한 달 동안 친구도 안만나고 엄청 열심히 식단 조절도 하고 꾸준히 운동을 했어요',
                maxLines: 2,
                style: TextStyle(
                  color: FitwithColors.getSecondary300(),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    '사용 후기',
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
                  Text('김회원'),
                  Container(
                    height: 20.0,
                    child: VerticalDivider(
                      color: FitwithColors.getSecondary300(),
                      width: 25.0,
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_outline_outlined,
                          color: FitwithColors.getSecondary200(),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '200',
                          style: TextStyle(
                            color: FitwithColors.getSecondary300(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          color: FitwithColors.getSecondary200(),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '200',
                          style: TextStyle(
                            color: FitwithColors.getSecondary300(),
                          ),
                        ),
                      ],
                    ),
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
