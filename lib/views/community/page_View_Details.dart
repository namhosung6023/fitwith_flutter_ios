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
        buildScaffold(context, _buildBody(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: FitwithColors.getSecondary300()),
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Image.asset(
                'assets/logo_blue.png',
                height: 25,
              ),
            )),
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
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     IconButton(icon: Icon(Icons.arrow_back_ios_sharp, size: 20,color: FitwithColors.getSecondary300(),), onPressed: (){
              //       Navigator.pop(context);
              //     }),
              //     Text('뒤로', style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //       color: FitwithColors.getSecondary300()
              //     ),),
              //   ],
              // ),
              Text(
                widget.item.type,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: FitwithColors.getPrimaryColor()),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: FitwithColors.getSecondary400()),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.item.avatar != null && widget.item.avatar != ''
                      ? Image.network(
                          widget.item.avatar,
                          height: 50,
                        )
                      : Image.asset(
                          'assets/Profile.png',
                          height: 40,
                        ),
                  SizedBox(height: 60, width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.username,
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: FitwithColors.getSecondary400()),
                      ),
                      Text(widget.item.createdAt.toString(),
                        style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: FitwithColors.getSecondary300()),),
                    ],
                  ),
                  widget.item.userId ==
                          Provider.of<User>(context, listen: false).userId
                      ? InkWell(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              deleteCommunity(widget.item.id);
                            },
                            child: Text('삭제'),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Text(widget.item.contents, style: TextStyle(
                  fontSize: 16
                ),),
                padding: EdgeInsets.symmetric(vertical: 20),
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
