import 'package:flutter/material.dart';

import '../core/app_export.dart';

enum BottomBarEnum { Home, Qrcode, People, Analytics }

// ignore: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: Icons.home,
      activeIcon: Icons.home,
      title: "Home",
      type: BottomBarEnum.Home,
    ),
    // BottomMenuModel(
    //   icon: Icons.qr_code,
    //   activeIcon: Icons.qr_code,
    //   title: "QR Code",
    //   type: BottomBarEnum.Qrcode,
    // ),
    BottomMenuModel(
      icon: Icons.people,
      activeIcon: Icons.people,
      title: "People",
      type: BottomBarEnum.People,
    ),
    BottomMenuModel(
      icon: Icons.analytics,
      activeIcon: Icons.analytics,
      title: "Analytics",
      type: BottomBarEnum.Analytics,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.v,
      decoration: BoxDecoration(
        color: appTheme.gray100,
        border: Border(
          top: BorderSide(
            color: appTheme.teal50,
            width: 1.h,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  bottomMenuList[index].icon,
                  size: 32.v,
                  color: theme.colorScheme.primaryContainer,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                    ),
                  ),
                )
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  bottomMenuList[index].activeIcon,
                  size: 32.v,
                  color: theme.colorScheme.onPrimary,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.labelLargeOnPrimary.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  IconData icon;
  IconData activeIcon;
  String? title;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
