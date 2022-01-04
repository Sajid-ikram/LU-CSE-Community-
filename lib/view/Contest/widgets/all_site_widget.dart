import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/Contest/SubPage/individual_contest_page.dart';

Container allSitesWidget() {
  return Container(
    margin: EdgeInsets.only(left: 10.w),
    height: 180.h,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          spreadRadius: 3,
          blurRadius: 15,
        )
      ],
    ),
    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualContestPage(
                  site: allCategory[index],
                ),
              ),
            );
          },
          child: Container(
            width: 260.w,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(15.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30.h,
                      width: 30.h,
                      child: SvgPicture.asset(
                        "assets/svg/${allCategory[index]}.svg",
                        semanticsLabel: 'A red up arrow',
                      ),
                    ),
                    InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {},
                      child: Icon(
                        Icons.favorite,
                        size: 18.sp,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    allCategory[index],
                    style: GoogleFonts.inter(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    allCotes[index],
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: 3,
    ),
  );
}
