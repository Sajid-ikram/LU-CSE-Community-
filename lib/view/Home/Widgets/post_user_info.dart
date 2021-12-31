import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


Row postUserInfo() {
  return Row(
    children: [
      SizedBox(
        height: 40.h,
        width: 40.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            "assets/verification.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
      SizedBox(width: 15.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User name",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "2h",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      const Spacer(),
      Icon(
        Icons.favorite,
        size: 20.sp,
        color: Colors.red,
      ),
    ],
  );
}