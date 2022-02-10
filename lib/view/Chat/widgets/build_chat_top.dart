import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/chat_provider.dart';
import 'package:provider/provider.dart';

Padding buildChatTop(BuildContext context,String name,String url) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.sp),
    child: SizedBox(
      height: 50.h,
      width: 400.w,
      child: Row(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Provider.of<ChatProvider>(context,listen: false).chatId = "";
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.arrow_back_ios,
                size: 26.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          url != ""
              ? CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18.sp,
            backgroundImage: NetworkImage(
              url,
            ),
          )
              : CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18.sp,
            backgroundImage: const AssetImage("assets/profile.jpg"),
          ),
          SizedBox(width: 10.w),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}