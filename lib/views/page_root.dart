import 'package:fitwith/providers/provider_page_index.dart';
import 'package:fitwith/providers/provider_user.dart';
import 'package:fitwith/views/community/page_community.dart';
import 'package:fitwith/views/mypage/page_mypage.dart';
import 'package:fitwith/views/premium/page_premium_member.dart';
import 'package:fitwith/views/premium/page_premium_trainer.dart';
import 'package:fitwith/views/shopping/page_shopping.dart';
import 'package:fitwith/views/training/page_training.dart';
import 'package:fitwith/widgets/custom_appbar.dart';
import 'package:fitwith/widgets/custom_loading.dart';
import 'package:fitwith/widgets/custom_navigationbar.dart';
import 'package:fitwith/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = true;

  Future<void> _getUser() async {
    String _message = await Provider.of<User>(context, listen: false).getUser();
    if (_message != null) buildSnackBar(context, _message);

    setState(() => _loading = false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------- root_page build -----------');

    List<Widget> _pages = [
      Consumer<User>(
        builder: (context, user, child) {
          return (user.type == '2')
              ? PremiumTrainerPage()
              : PremiumMemberPage(context: context);
        },
      ),
      CommunityPage(),
      TrainingPage(),
      ShoppingPage(),
      MyPage()
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: CustomAppBar(
          backgroundColor: Colors.white,
        ),
      ),
      body: _loading
          ? buildLoading(color: Colors.white)
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Consumer<PageIndex>(builder: (context, value, child) {
                return _pages[value.index];
              }),
            ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }
}
