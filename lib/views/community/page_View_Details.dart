import 'package:fitwith/config/colors.dart';
import 'package:fitwith/models/model_beta.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class CommunityDetailPage extends StatefulWidget {
  final item;
  CommunityDetailPage({ Key key, this.item }) : super(key: key);
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
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Image.asset('assets/logo_blue.png'),
            )
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
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios_sharp), onPressed: (){}),
                  Text('뒤로'),
                ],
              ),
              Text(widget.item.type),
              Text(widget.item.title),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.item.avatar != null && widget.item.avatar !='' ? Image.network(
                      widget.item.avatar, height: 50,) : Image.asset('assets/basicProfile.png',height: 50,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.username),
                      Text(widget.item.createdAt.toString()),
                    ],
                  ),
                  InkWell(
                    // onTap: ,
                    child: Text('삭제'),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Container(
                child: Text(widget.item.contents),
               padding : EdgeInsets.symmetric( vertical: 20 ),
                // padding: const EdgeInsets.fromLTRB(0, 20, 200, 20),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide( color: FitwithColors.getSecondary200()),
                      bottom: BorderSide( color: FitwithColors.getSecondary200()),
                    )
                    // border: Border.all(color: Colors.blueAccent)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



