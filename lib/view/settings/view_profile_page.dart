import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/Chat/chat.dart';
import 'package:lu_cse_community/view/settings/add_link.dart';
import 'package:lu_cse_community/view/settings/widgets/build_profile_part.dart';
import 'package:lu_cse_community/view/settings/widgets/build_top.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sign_in_sign_up/widgets/promise.dart';

class ViewProfile extends StatefulWidget {
   ViewProfile(
      {Key? key,
      required this.name,
      required this.email,
      required this.batch,
      required this.role,
      required this.section,
      required this.isViewer,
      required this.bio,
      this.github,
      this.facebook,
      this.twitter,
      this.linkedin,
      required this.url,
      required this.uid})
      : super(key: key);
  final String name;
  final String email;
  final String role;
  final String batch;
  final String section;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? github;

  final String bio;
  final String url;
  final String uid;
  final bool isViewer;

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
    var pro = Provider.of<ProfileProvider>(context, listen: false);
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
            child: SizedBox(
              width: 350.w,
              height: 50.h,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.isViewer) {
                        if (widget.linkedin != "") {
                          openUrl(widget.linkedin!);
                        } else {
                          snackBar(context, "Link not provided");
                        }
                      } else if (pro.linkedin != "") {
                        openUrl(pro.linkedin);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLink(
                              iconData: FontAwesomeIcons.linkedinIn,
                              color: const Color(0xff0077b5),
                            ),
                          ),
                        );
                      }
                    },
                    child: buildSocialSites(
                      FontAwesomeIcons.linkedinIn,
                      const Color(0xff0077b5),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.isViewer) {
                        if (widget.twitter != "") {
                          openUrl(widget.twitter!);
                        } else {
                          snackBar(context, "Link not provided");
                        }
                      } else if (pro.twitter != "") {
                        openUrl(pro.twitter);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLink(
                              iconData: FontAwesomeIcons.twitter,
                              color: const Color(0xff00acee),
                            ),
                          ),
                        );
                      }
                    },
                    child: buildSocialSites(
                      FontAwesomeIcons.twitter,
                      const Color(0xff00acee),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.isViewer) {
                        if (widget.facebook != "") {
                          openUrl(widget.facebook!);
                        } else {
                          snackBar(context, "Link not provided");
                        }
                      } else if (pro.facebook != "") {
                        openUrl(pro.facebook);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLink(
                              iconData: FontAwesomeIcons.facebook,
                              color: const Color(0xff3b5998),
                            ),
                          ),
                        );
                      }
                    },
                    child: buildSocialSites(
                      FontAwesomeIcons.facebook,
                      const Color(0xff3b5998),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.isViewer) {
                        if (widget.github != "") {
                          openUrl(widget.github!);
                        } else {
                          snackBar(context, "Link not provided");
                        }
                      } else if (pro.github != "") {
                        openUrl(pro.github);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLink(
                              iconData: FontAwesomeIcons.github,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                    child: buildSocialSites(
                      FontAwesomeIcons.github,
                      Colors.black,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            name: widget.name,
                            url: widget.url,
                            uid: widget.uid,
                          ),
                        ),
                      );
                    },
                    child: buildSocialSites(
                      FontAwesomeIcons.comments,
                      Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> openUrl(String url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
      );
      return true;
    } catch (e) {
      snackBar(context, "An error accor");
      return false;
    }
  }

  SingleChildScrollView buildStackBottom() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            buildTop("Profile", context),
            SizedBox(height: 15.h),
            BuildProfilePart(
              isViewMode: true,
              name: widget.name,
              email: widget.email,
              url: widget.url,
              isViewer: widget.isViewer,
            ),
            SizedBox(height: 30.h),
            _buildContainer("Name", widget.name),
            if (widget.role == "Student" || widget.role == "Moderator")
              _buildContainer("Batch", widget.batch),
            if (widget.role == "Student" || widget.role == "Moderator")
              _buildContainer("ID & Section",
                  getIdAndSection(widget.email, widget.section)),
            _buildContainer(
                "Bio", widget.bio.isEmpty ? "No bio available" : widget.bio),
            SizedBox(height: 50.h)
          ],
        ),
      ),
    );
  }

  Container buildSocialSites(IconData iconData, Color color) {
    return Container(
      height: 40.w,
      width: 40.w,
      margin: EdgeInsets.only(
          right: iconData == FontAwesomeIcons.comments ? 0 : 15),
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
                textAlign: TextAlign.left,
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
