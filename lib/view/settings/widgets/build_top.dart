import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Stack buildTop(String text ,BuildContext context) {
  return Stack(
    children: [
      InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20.sp,
        ),
      ),
      SizedBox(width: 130.w),
      Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}