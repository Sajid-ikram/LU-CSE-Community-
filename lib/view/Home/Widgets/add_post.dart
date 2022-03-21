import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/Home/SubPage/add_new_post_page.dart';
import 'package:provider/provider.dart';

import '../../public_widget/photo_view.dart';
import '../../settings/view_profile_page.dart';

Padding addPost(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(32.w, 43.h, 32.w, 10.h),
    child: Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            provider.profileUrl != ""
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ViewProfile(
                            uid: provider.currentUserUid,
                            isViewer: false,
                            batch: provider.batch,
                            bio: provider.bio,
                            email: provider.email,
                            name: provider.profileName,
                            role: provider.role,
                            section: provider.section,
                            url: provider.profileUrl,
                          );
                        }),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: NetworkImage(
                        provider.profileUrl,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ViewProfile(
                            uid: provider.currentUserUid,
                            isViewer: false,
                            batch: provider.batch,
                            bio: provider.bio,
                            email: provider.email,
                            name: provider.profileName,
                            role: provider.role,
                            section: provider.section,
                            url: provider.profileUrl,
                          );
                        }),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
                  ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewPostPage(page: "Home"),
                    ),
                  );
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
                      "What's on your mind, ${provider.profileName} ?",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
