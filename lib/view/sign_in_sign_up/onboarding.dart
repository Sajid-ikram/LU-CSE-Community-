import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/promise.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  height: 140.h,
                  width: 140.w,
                  child: Image.asset("assets/top_deco.png"),
                ),
              ],
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 90.h),
                  SizedBox(
                    height: 160.h,
                    width: 160.w,
                    child: Image.asset(
                      "assets/lu.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: Text(
                      "CSE",
                      style: GoogleFonts.nunitoSans(
                          fontSize: 103.sp,
                          color: const Color(0xff072678),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 110.w),
                      Text(
                        "COMMUNITY",
                        style: TextStyle(
                            fontSize: 22.sp,
                            color: const Color(0xff072678),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pushNamed("SignUp");
                    },
                    child: buildButton("Sign Up",350,20,56),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("SignIn");
                    },
                    child: buildOutlineButton("Sign In"),
                  ),
                  SizedBox(height: 180.h),
                  buildPromise(18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
