import 'package:date_format/date_format.dart';
import 'package:fitwith/api/api_beta.dart';
import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_beta.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/community/page_community.dart';
import 'package:fitwith/views/community/page_write.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatefulWidget {
  final item;
  CommunityDetailPage({Key key, this.item}) : super(key: key);
  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  Size screenSize;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildScaffold(
          context,
          _buildBody(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: FitwithColors.getSecondary300()),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/logo_blue.png',
              height: 25,
            ),
          ),
        ),
        _loading ? buildLoading() : Container()
      ],
    );
  }

  Widget _buildBody() {
    var screenSize = MediaQuery.of(context).size;
    print(widget.item);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.type,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: FitwithColors.getPrimaryColor()),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                widget.item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: FitwithColors.getSecondary400()),
              ),
              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.item.avatar != null && widget.item.avatar != ''
                          ? ClipOval(
                              child: Image.network(
                                widget.item.avatar,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/Profile.png',
                              height: 40,
                            ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.username,
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: FitwithColors.getSecondary400()),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '${formatDate(widget.item.createdAt, [
                              yyyy,
                              '.',
                              mm,
                              '.',
                              dd,
                              ' ' ' ',
                              HH,
                              ':',
                              nn
                            ])}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: FitwithColors.getSecondary250()),
                          ),
                        ],
                      ),
                    ],
                  ),
                  widget.item.userId ==
                          Provider.of<User>(context, listen: false).userId
                      ? Container(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              deleteCommunity(widget.item.id);
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: FitwithColors.getBasicOrange()),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  widget.item.contents,
                  textAlign: TextAlign.justify,
                  style: TextStyle(height: 1.2, fontSize: 16),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: FitwithColors.getSecondary200()),
                  bottom: BorderSide(color: FitwithColors.getSecondary200()),
                )
                    // border: Border.all(color: Colors.blueAccent)
                    ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       child: OutlineButton(
              //         shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              //         onPressed: ()=> CommonUtils.movePage(context, CommunityPage()),
              //         borderSide: BorderSide(
              //             color: FitwithColors.getPrimaryColor()
              //         ),
              //         child: Text('목록',
              //           style: TextStyle(
              //               color: FitwithColors.getPrimaryColor()),
              //         ),
              //       )
              //     ),
              //     InkWell(
              //         child: TextButton(
              //           onPressed: ()=> CommonUtils.movePage(context, WritePage()),
              //             style: ButtonStyle(
              //                 backgroundColor: MaterialStateProperty.all(FitwithColors.getPrimaryColor())
              //             ),
              //           child: Text('글 작성하기',
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         )
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
