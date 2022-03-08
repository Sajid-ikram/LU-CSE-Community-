import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/Contest/widgets/all_site_widget.dart';
import 'package:lu_cse_community/view/Contest/widgets/individual_site_widget.dart';

class Contest extends StatelessWidget {
  const Contest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 210.h,
              width: 414.w,
              decoration: BoxDecoration(
                color: mainColor,
                image: const DecorationImage(
                    image: AssetImage("assets/appbar.png"), fit: BoxFit.fill),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35.sp),
                  bottomLeft: Radius.circular(35.sp),
                ),
              ),
              child: Align(
                alignment: const Alignment(1, 1),
                child: Padding(
                  padding: const EdgeInsets.all(31),
                  child: Text(
                    "Hey, Where would you like to compete today?",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22.w, top: 40.h, bottom: 12.h),
                child: Text(
                  "All Sites",
                  style: TextStyle(
                    color: nevColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            allSitesWidget(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22.w, top: 30.h),
                child: Text(
                  "Individual Site",
                  style: TextStyle(
                    color: nevColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            individualSiteWidget(),
          ],
        ),
      ),
    );
  }




}
