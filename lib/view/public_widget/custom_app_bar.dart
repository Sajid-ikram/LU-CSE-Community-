import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar customAppBar(String text, BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: Text(
      text,
      style: TextStyle(
        fontSize: 18.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Padding(
      padding:  EdgeInsets.only(left: 25.w),
      child: IconButton(

        icon:  Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22.sp,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}
