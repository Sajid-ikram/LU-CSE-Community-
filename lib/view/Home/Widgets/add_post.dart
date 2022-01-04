import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';

Padding addPost(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 10.h),
    child: Row(
      children: [
        Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return provider.profileUrl != ""
                ? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 21,
                    backgroundImage: NetworkImage(
                      provider.profileUrl,
                    ),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 21,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  );
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("AddNewPostPage");
            },
            child: Container(
              margin: EdgeInsets.only(left: 15.w),
              padding: EdgeInsets.only(left: 15.w),
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xffF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's on your mind, User Name?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
