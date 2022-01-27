import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/settings/widgets/build_profile_part.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SizedBox(height: 80.h),
                BuildProfilePart(isViewMode: false),
                SizedBox(height: 30.h),
                const Divider(thickness: 4, color: Color(0xffF6F6F7)),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 15.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account Setting",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("ViewProfile");
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 24.w, top: 15.h, right: 24.w),
                    height: 50.h,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.profileName,
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "View your information",
                              style: GoogleFonts.inter(
                                  color: const Color(0xff666666),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 18.sp)
                      ],
                    ),
                  ),
                ),
                const Divider(
                    thickness: 4, color: Color(0xffF6F6F7), height: 40),
                SizedBox(height: 20.h),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("EditProfile");
                    },
                    child: buildRow("Edit Profile")),
                const Divider(
                    thickness: 1.5, color: Color(0xffF6F6F7), height: 25),
                buildRow("Change Password"),
                const Divider(
                    thickness: 1.5, color: Color(0xffF6F6F7), height: 25),
                buildRow("Post"),
                const Divider(
                    thickness: 1.5, color: Color(0xffF6F6F7), height: 25),
                GestureDetector(
                    onTap: () {}, child: buildRow("Privecy & Policy")),
                const Divider(
                    thickness: 1.5, color: Color(0xffF6F6F7), height: 25),
                GestureDetector(
                  onTap: () {
                    _showMyDialog(context);
                  },
                  child: buildRow("Log Out"),
                ),
                const Divider(
                    thickness: 1.5, color: Color(0xffF6F6F7), height: 30),
                /*Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 10, color: Colors.black12)
                          ],
                        ),
                        height: 30,
                        width: 30,
                        child: Icon(
                          FontAwesomeIcons.reply,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Text(
                        "Logout",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Spacer()*/
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LogOut'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to LogOut'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Provider.of<Authentication>(context).signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container buildRow(String text) {
    return Container(
      padding: EdgeInsets.only(left: 24.w, right: 24.w),
      height: 23.h,
      color: Colors.transparent,
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
                color: const Color(0xff666666),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 18.sp)
        ],
      ),
    );
  }
}
