import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_page_index.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:fitwith/views/account/page_login.dart';
import 'package:fitwith/views/page_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/provider_trainer.dart';
import 'providers/provider_user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageIndex>(create: (_) => PageIndex()),
        ChangeNotifierProvider<User>(create: (_) => User()),
        ChangeNotifierProvider<Trainer>(create: (_) => Trainer()),
      ],
      child: MaterialApp(
        builder: (context, child) => ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        ),
        debugShowCheckedModeBanner: false,
        title: 'FITWITH',
        theme: ThemeData(
          primaryColor: FitwithColors.getPrimaryColor(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InitPage(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Future<void> _pageRoute() async {
    String _token = await Provider.of<User>(context, listen: false).getToken();
    CommonUtils.movePage(
      context,
      _token == null ? LoginPage() : RootPage(),
      isReplace: true,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _pageRoute());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------- main_page build -----------');
    return Container();
  }
}
