import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

import 'Widgets/add_post.dart';
import 'Widgets/post_user_info.dart';
import 'Widgets/search_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 700.h,
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return addPost(context);
                  }
                  return Container(
                    width: 350.w,
                    margin: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 10.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 21.w),
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
                    child: Column(
                      children: [
                        postUserInfo(),
                        SizedBox(height: 18.h),
                        Text(
                          "Based on the user rating, CodeChef user can proceed with the applicable division mentioned below to participate.",
                          style: GoogleFonts.inter(fontSize: 15.sp),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: 308.w,
                          height: 226.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/signin.png",
                                fit: BoxFit.fill,
                              )),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            buildReactButton("Like"),
                            buildText("400"),
                            buildReactButton("Comment"),
                            buildText("400"),
                            buildReactButton("Share"),
                            const Spacer(),
                            const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount: 10,
              ),
            ),
          ),
          buildSearch(),
        ],
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 22.w),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Padding buildReactButton(String name) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: SizedBox(
        height: 20.h,
        width: 20.h,
        child: SvgPicture.asset(
          "assets/svg/$name.svg",
          semanticsLabel: 'A red up arrow',
        ),
      ),
    );
  }
}
