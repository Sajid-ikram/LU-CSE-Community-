import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


Padding chatTop(BuildContext context) {
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
           Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("AllUsers");
              },
              child: Icon(
                FontAwesomeIcons.users,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}