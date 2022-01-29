import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


Padding chatTop() {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 30.sp),
    child: SizedBox(
      height: 40.h,
      width: 400.w,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Massage",
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    ),
  );
}