import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

Align buildSearch() {
  return Align(
    alignment: const Alignment(0, -0.85),
    child: Container(
      height: 48.h,
      width: 350.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 6,
            blurRadius: 9,
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.7.sp),
          border: InputBorder.none,
          focusColor: mainColor,
          prefixIcon: Icon(
            Icons.search,
            size: 24.sp,
          ),
          hintText: "Search places",
          hintStyle: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ),
    ),
  );
}