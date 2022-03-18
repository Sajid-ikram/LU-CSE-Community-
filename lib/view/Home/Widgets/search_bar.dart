import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/search_provider.dart';
import 'package:provider/provider.dart';

Align buildSearch(BuildContext context, String page) {
  return Align(
    alignment: const Alignment(0, -0.82),
    child: Container(
      height: 50.h,
      width: 350.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 4,
            blurRadius: 14,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 24.sp,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                if (page == "Home") {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchPost(value);
                } else if (page == "LUCC_ACM") {
                  Provider.of<SearchProvider>(context, listen: false)
                      .changeSearchLUCCAndACMPost(value);
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3.h),
                border: InputBorder.none,
                focusColor: mainColor,
                /*prefixIcon: Icon(
                  Icons.search,
                  size: 24.sp,
                ),*/
                hintText: "Search here",
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
