import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/settings/view_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoOfAPost extends StatefulWidget {
  const UserInfoOfAPost(
      {Key? key, required this.uid, required this.time, required this.pageName})
      : super(key: key);
  final String pageName;
  final String uid;
  final String time;

  @override
  _UserInfoOfAPostState createState() => _UserInfoOfAPostState();
}

class _UserInfoOfAPostState extends State<UserInfoOfAPost> {
  late DocumentSnapshot data;
  bool isLoading = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    data = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileInfoByUID(widget.uid);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    if (to.difference(from).inHours > 24) {
      return (to.difference(from).inHours / 24).round().toString() + " day";
    } else if (to.difference(from).inMinutes < 60) {
      return to.difference(from).inMinutes.toString() + " min";
    } else {
      return to.difference(from).inHours.toString() + " hour";
    }
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic \u003cZTg0NDI1YzMtNGU3Mi00MDhmLTkwMTYtMmRhYjZhYTJjNDRl\u003e'
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "included_segments": ["Subscribed Users"],
        //"include_player_ids": tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        //"android_accent_color": "FF9976D2",

        //"small_icon":"ic_stat_onesignal_default",

        "large_icon":
            "https://firebasestorage.googleapis.com/v0/b/lu-cse-community.appspot.com/o/profileImage%2FDWErXMxXmbfNTktIXXB0Gy8s57k2?alt=media&token=2745ac63-407a-4284-bd1a-755356571019",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey, radius: 20.sp),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("User name", style: TextStyle(fontSize: 14)),
                    Text("...h", style: TextStyle(fontSize: 13)),
                  ],
                ),
                const Spacer(),
                if (widget.pageName == "home" && widget.pageName != "notice")
                  Icon(Icons.favorite, size: 20.sp, color: Colors.grey),
              ],
            ),
          )
        : widget.pageName == "home" || widget.pageName == "notice"
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  returnImage(data),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.pageName == "comment") SizedBox(height: 5.h),
                      buildNameText(14),
                      SizedBox(height: 2.h),
                      buildTimeText(),
                    ],
                  ),
                  const Spacer(),
                  if (widget.pageName != "notice")
                    InkWell(
                      onTap: () async {
                        print("******************");
                        var a = await sendNotification(
                            ["fab732a6-8371-11ec-9974-d6a81ba95cb1"],
                            "Text for test",
                            "send by ikram ");
                        print(a.body);
                        print(a.statusCode);
                        print("******************2");
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 20.sp,
                        color: Colors.red,
                      ),
                    ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  returnImage(data),
                  SizedBox(width: 12.w),
                  buildNameText(15),
                  SizedBox(width: 10.w),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: buildTimeText(),
                  ),
                ],
              );
  }

  GestureDetector buildNameText(double size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfile(
              uid: data.id,
              isViewer: true,
              batch: data["batch"],
              bio: data["bio"],
              email: data["email"],
              name: data["name"],
              role: data["role"],
              section: data["section"],
              url: data["url"],
            ),
          ),
        );
      },
      child: Row(
        children: [
          Text(
            data["name"],
            style: GoogleFonts.inter(
              fontSize: size.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.pageName == "notice")
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.star,
                color: Color(0xffFFCE31),
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }

  Text buildTimeText() {
    return Text(
      daysBetween(DateTime.parse(widget.time), DateTime.now()),
      style: GoogleFonts.inter(
        color: const Color(0xff9e9ea8),
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

Widget returnImage(DocumentSnapshot data) {
  return data["url"] != ""
      ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: NetworkImage(
            data["url"],
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: const AssetImage("assets/profile.jpg"),
        );
}
