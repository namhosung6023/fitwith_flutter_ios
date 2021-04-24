import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// 공통으로 사용
class CommonUtils {
  static const String TYPE_MEMBER = 'MEMBER'; // fixme :: 디버그용
  static const String TYPE_TRAINER = 'TRAINER'; // fixme :: 디버그용

  static const String MODE_EDIT = 'EDIT';
  static const String MODE_VIEW = 'VIEW';

  static const String PAGE_TYPE_EDIT = 'EDIT';
  static const String PAGE_TYPE_COMPLETE = 'COMPLETE';

  static const double DEFAULT_PAGE_PADDING = 20.0;
  static const double DEFAULT_PAGE_BOTTOM_PADDING = 50.0;

  /// Hex 색깔 코드로 Color 가져오기
  static Color getColorByHex(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('0xff$hex'));
  }

  /// 페이지 이동
  ///   isReplace : 현재 페이지를 이동시킬지
  ///   isPushAndRemoveUntil : 모든 페이지 스텍을 없애고 페이지 이동시킬지
  static Future<dynamic> movePage(BuildContext context, newRoute,
      {bool isReplace = false, bool isPushAndRemoveUntil = false}) {
    if (isPushAndRemoveUntil) {
      if(Platform.isIOS) {
        return Navigator.pushAndRemoveUntil(
            context, CupertinoPageRoute(builder: (context) => newRoute), (route) => false);
      } else {
        return Navigator.pushAndRemoveUntil(
            context, PageRouteBuilder(pageBuilder: (context, _, __) => newRoute), (route) => false);
      }
    }

    if (isReplace) {
      if(Platform.isIOS) {
        return Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => newRoute));
      } else {
        return Navigator.pushReplacement(
            context, PageRouteBuilder(pageBuilder: (context, _, __) => newRoute));
      }
    }

    if(Platform.isIOS) {
      return Navigator.push(
          context, CupertinoPageRoute(builder: (context) => newRoute));
    } else {
      return Navigator.push(
              context, PageRouteBuilder(pageBuilder: (context, _, __) => newRoute));
    }

  }

  /// 이름을 통한 페이지 이동
  ///   isReplace : 현재 페이지를 이동시킬지
  ///   isPushAndRemoveUntil : 모든 페이지 스텍을 없애고 페이지 이동시킬지
  static Future<dynamic> moveNamedPage(BuildContext context, String routeName,
      {Object arguments,
      bool isReplace = false,
      bool isPushAndRemoveUntil = false}) {
    if (isPushAndRemoveUntil) {
      return Navigator.pushNamedAndRemoveUntil(
          context, routeName, (route) => false,
          arguments: arguments);
    }

    if (isReplace) {
      return Navigator.pushReplacementNamed(context, routeName,
          arguments: arguments);
    }

    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// 드로워 메뉴에서 페이지 이동
  ///   isReplace : 현재 페이지를 이동시킬지
  ///   isPushAndRemoveUntil : 모든 페이지 스텍을 없애고 페이지 이동시킬지
  static Future<dynamic> movePageDrawer(BuildContext context, Object newRoute,
      {Object arguments,
      bool isReplace = false,
      bool isPushAndRemoveUntil = false}) {
    Navigator.pop(context);

    if (isPushAndRemoveUntil) {
      return Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => newRoute), (route) => false);
    }

    if (isReplace) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => newRoute));
    }

    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => newRoute));
  }
}
