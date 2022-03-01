import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/settings/settings.dart';
import 'Chat/chat_user.dart';
import 'Contest/contest.dart';
import 'Home/home.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  var _bottomNavIndex = 0;

  final List<IconData> iconList = [
    Icons.home,
    Icons.add,
    Icons.chat,
    Icons.settings,
  ];

  changeIndex() {
    setState(() {
      _bottomNavIndex = 2;
    });
  }

  List<Widget> pageList = [
    const Home(),
    const Contest(),
    const ChatUser(),
    const Settings(),
    //const StoriesHorizontal()
  ];

  List<String> pageName = [
    "Home",
    "Contest",
    "Chat",
    "Setting"
    //const StoriesHorizontal()
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: pageList[_bottomNavIndex],
      extendBody: true,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("Dashboard");
          },
          child: Container(
            height: 45.h,
            width: 45.h,
            decoration: BoxDecoration(
              border: Border.all(color: secondColor, width: 2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.dashboard_rounded,
              color: nevColor,
              size: 21.sp,
            ),
          ),
          elevation: 11,
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 22.h,
                width: 24.h,
                child: SvgPicture.asset(
                  "assets/svg/${pageName[index]}.svg",
                  color: isActive ? secondColor : Colors.white,
                  semanticsLabel: 'A red up arrow',
                ),
              ),
              const SizedBox(height: 4),
              if (isActive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? secondColor : nevColor,
                    ),
                  ),
                )
            ],
          );
        },

        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: nevColor,
        leftCornerRadius: 22.sp,
        rightCornerRadius: 22.sp,
        gapWidth: 100.w,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        itemCount: 4,
        //other params
      ),
    );
  }
}
