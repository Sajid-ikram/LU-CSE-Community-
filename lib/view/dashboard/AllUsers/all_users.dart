import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/all_users_provider.dart';
import 'package:lu_cse_community/provider/search_provider.dart';
import 'package:lu_cse_community/view/dashboard/AllUsers/widgets/teacher_pending_button.dart';
import 'package:lu_cse_community/view/dashboard/AllUsers/widgets/users_list.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        width: 414,
        height: 837,
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Consumer<AllUserProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    InkWell(
                        onTap: () {
                          provider.changeFilter("Student");

                        },
                        child: buildButton("Student", 165, 18, 60,
                            provider.selectedFilter == "Student")),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        provider.changePendingPage(false);
                        provider.changeFilter("Teacher");
                      },
                      child: buildButton(
                        "Teacher",
                        165,
                        18,
                        60,
                        (provider.selectedFilter == "Teacher" ||
                            provider.selectedFilter == "TeacherP"),
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            Consumer<AllUserProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    InkWell(
                        onTap: () {
                          provider.changeFilter("Moderator");
                        },
                        child: buildButton("Moderator", 165, 18, 60,
                            provider.selectedFilter == "Moderator")),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          provider.changeFilter("Admin");
                        },
                        child: buildButton("Admin", 165, 18, 60,
                            provider.selectedFilter == "Admin")),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            const TeacherPendingButton(),
            Container(
              height: 48.h,
              width: 350.w,
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchUser(value);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.7.sp),
                  border: InputBorder.none,
                  focusColor: mainColor,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.sp,
                  ),
                  hintText: "Search here",
                  hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              children: [
                Text(
                  "Name",
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 130.w,
                  child: Center(
                    child: Text(
                      "Role",
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            SizedBox(height: 12.h),
            const Expanded(child: UserList())
          ],
        ),
      ),
    );
  }
}

Container buildButton(
    String text, double width, double size, double height, bool showBorder) {
  return Container(
    height: height.h,
    width: width.w,
    decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: showBorder
              ? Colors.deepOrangeAccent.withOpacity(0.6)
              : Colors.transparent,
        )),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: size.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
