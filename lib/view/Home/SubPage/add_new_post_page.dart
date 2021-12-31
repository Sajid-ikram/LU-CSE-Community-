import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

class AddNewPostPage extends StatelessWidget {
  const AddNewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                  contentPadding: EdgeInsets.all(10.sp),
                  border: InputBorder.none,
                  focusColor: mainColor,

                  hintText: "Write Something",
                  hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ),
            TextButton(onPressed: () {}, child: Text("Select image")),
            TextButton(onPressed: () {}, child: Text("Uppload Image")),
            TextButton(onPressed: () {}, child: Text("Post")),
          ],
        ),
      ),
    );
  }
}
