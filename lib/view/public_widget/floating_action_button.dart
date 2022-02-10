import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/constant.dart';
import '../Home/SubPage/add_new_post_page.dart';

FloatingActionButton customFloatingActionButton(BuildContext context){
  return FloatingActionButton(

    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNewPostPage(page: "Notice"),
        ),
      );
    },
    child: Container(
      height: 45.h,
      width: 45.h,
      decoration: BoxDecoration(
        border: Border.all(color: secondColor, width: 2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.add,
        color: nevColor,
        size: 25.sp,
      ),
    ),
    elevation: 11,
    backgroundColor: Colors.white,
  );
}