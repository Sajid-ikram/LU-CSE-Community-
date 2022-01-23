import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

Row buildRowButton(String name, bool isSelected) {
  return Row(
    children: [
      Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          color: mainColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(width: 10.w),
      Container(
        height: 15.sp,
        width: 15.sp,
        decoration: BoxDecoration(
          border: Border.all(color: mainColor),
          shape: BoxShape.circle,
          color: isSelected ? mainColor : Colors.white,
        ),
      )
    ],
  );
}