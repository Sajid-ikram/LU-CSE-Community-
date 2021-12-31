import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

Padding addPost(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 10.h),
    child: Row(
      children: [
        SizedBox(
          height: 45.h,
          width: 45.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/verification.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("AddNewPostPage");
            },
            child: Container(
              margin: EdgeInsets.only(left: 15.w),
              padding: EdgeInsets.only(left: 15.w),
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xffF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's on your mind, User Name?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
