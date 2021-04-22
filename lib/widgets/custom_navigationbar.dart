import 'package:fitwith/config/colors.dart';
import 'package:fitwith/providers/provider_page_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget buildBottomNavigationBar(BuildContext context) {
  return Consumer<PageIndex>(
    builder: (context, value, child) {
      return Container(
        // padding: EdgeInsets.symmetric(vertical: 1.0),
        // height: 67.0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: FitwithColors.getSecondary50(),
          selectedItemColor: FitwithColors.getPrimaryColor(),
          currentIndex: value.index,
          onTap: (index) => value.index = index,
          selectedFontSize: 12.0,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: SvgPicture.asset(
                  value.index == 0
                      ? 'assets/icons/navbar/premium_blue.svg'
                      : 'assets/icons/navbar/premium_gray.svg',
                ),
              ),
              label: '프리미엄',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: SvgPicture.asset(
                  value.index == 1
                      ? 'assets/icons/navbar/community_blue.svg'
                      : 'assets/icons/navbar/community_gray.svg',
                ),
              ),
              label: '커뮤니티',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: SvgPicture.asset(
                  value.index == 2
                      ? 'assets/icons/navbar/home_blue.svg'
                      : 'assets/icons/navbar/home_gray.svg',
                ),
              ),
              label: '트레이닝',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: SvgPicture.asset(
                  value.index == 3
                      ? 'assets/icons/navbar/shop_blue.svg'
                      : 'assets/icons/navbar/shop_gray.svg',
                ),
              ),
              label: '쇼핑몰',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: SvgPicture.asset(
                  value.index == 4
                      ? 'assets/icons/navbar/mypage_blue.svg'
                      : 'assets/icons/navbar/mypage_gray.svg',
                ),
              ),
              label: '마이페이지',
            )
          ],
        ),
      );
    },
  );
}
