import 'package:fitwith/config/colors.dart';
import 'package:fitwith/main.dart';
import 'package:fitwith/utils/utils_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final Color backgroundColor;
  CustomAppBar({Key key, this.backgroundColor}) : super(key: key);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final riveFileName = 'assets/flares/bell_blue_line.riv';
  Artboard _artBoard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      setState(() => _artBoard = file.mainArtboard
        ..addController(
          SimpleAnimation('bellActive'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(color: FitwithColors.getPrimaryColor()),
      backgroundColor: widget.backgroundColor,
      // backgroundColor: Colors.red,
      title: Image.asset(
        'assets/logo_blue.png',
        height: 20.0,
      ),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              CommonUtils.movePage(
                context,
                InitPage(),
                isPushAndRemoveUntil: true,
              );
            }),
        // _artBoard != null
        //     ? SizedBox(
        //         height: 43.0,
        //         width: 43.0,
        //         child: Rive(
        //           artboard: _artBoard,
        //           fit: BoxFit.cover,
        //         ),
        //       )
        //     : Container(),
        SizedBox(
          width: 8.0,
        )
      ],
    );
  }
}
