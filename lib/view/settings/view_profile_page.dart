import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/settings/widgets/build_profile_part.dart';
import 'package:lu_cse_community/view/settings/widgets/build_top.dart';
import 'package:provider/provider.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String getIdAndSection(String email, String section) {
    if (email.isEmpty) {
      return "Not available";
    } else if (email.length > 14) {
      return email.substring(4, 14) + " " + section;
    }
    return "Not available";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: 414.w,
            height: 837.h,
            child: buildStackBottom(),
          ),
          Positioned(
            bottom: 20,
            left: 32.w,
            child: Container(
              width: 350.w,
              height: 50.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 10,
                      color: Colors.grey.withOpacity(0.3))
                ],
              ),
              child: Row(
                children: [
                  buildSocialSites(
                    FontAwesomeIcons.linkedinIn,
                    const Color(0xff0077b5),
                  ),
                  buildSocialSites(
                    FontAwesomeIcons.twitter,
                    const Color(0xff00acee),
                  ),
                  buildSocialSites(
                    FontAwesomeIcons.facebook,
                    const Color(0xff3b5998),
                  ),
                  buildSocialSites(
                    FontAwesomeIcons.github,
                    Colors.black,
                  ),
                  const Spacer(),
                  buildSocialSites(
                    FontAwesomeIcons.comments,
                    Colors.black,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView buildStackBottom() {
    return SingleChildScrollView(
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              children: [
                SizedBox(height: 15.h),
                buildTop("Profile", context),
                SizedBox(height: 15.h),
                BuildProfilePart(isViewMode: true),
                SizedBox(height: 30.h),
                _buildContainer("Name", provider.profileName),
                if (provider.role == "Student" || provider.role == "Moderator")
                  _buildContainer("Batch", provider.batch),
                if (provider.role == "Student" || provider.role == "Moderator")
                  _buildContainer("ID & Section",
                      getIdAndSection(provider.email, provider.section)),
                _buildContainer("Bio",
                    provider.bio.isEmpty ? "No bio available" : provider.bio),
                SizedBox(height: 50.h)
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildSocialSites(IconData iconData, Color color) {
    return Container(
      height: 35.w,
      width: 35.w,
      margin: EdgeInsets.only(
          right: iconData == FontAwesomeIcons.comments ? 0 : 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 12.w,
              spreadRadius: 5,
              color: Colors.black.withOpacity(0.08))
        ],
      ),
      child: Icon(
        iconData,
        color: color,
        size: 18.sp,
      ),
    );
  }

  Container _buildContainer(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: 400.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
                color: const Color(0xff6a6a6a),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500),
          ),
          Container(
            width: 390.w,
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.fromLTRB(20.w, 15.h, 15.w, 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.07))
              ],
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                textAlign: TextAlign.justify,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4),
              ),
            ),
          )
        ],
      ),
    );
  }
}
