import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/Contest/SubPage/individual_contest_page.dart';


Container individualSiteWidget() {
  return Container(
    margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
    height: 800.h,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          spreadRadius: 3,
          blurRadius: 15,
        )
      ],
    ),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualContestPage(
                  site: individualSite[index],
                ),
              ),
            );
          },
          child: Container(
            height: 70.h,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: 45.h,
                  width: 45.h,
                  margin: EdgeInsets.fromLTRB(15.w, 0, 20.w, 0),
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          spreadRadius: 9,
                          blurRadius: 9)
                    ],
                  ),
                  child: Image.asset(
                      "assets/SitesLogo/${individualSite[index]}.png"),
                ),
                Text(
                  individualSite[index],
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.sp,
                ),
                SizedBox(width: 26.w)
              ],
            ),
          ),
        );
      },
      itemCount: individualSite.length,
    ),
  );
}
