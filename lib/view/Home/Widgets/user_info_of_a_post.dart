import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
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
                if (widget.pageName == "home")
                  Icon(Icons.favorite, size: 20.sp, color: Colors.grey),
              ],
            ),
          )
        : widget.pageName == "home"
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
                  Icon(
                    Icons.favorite,
                    size: 20.sp,
                    color: Colors.red,
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

  Text buildNameText(double size) {
    return Text(
      data["name"],
      style: GoogleFonts.inter(
        fontSize: size.sp,
        fontWeight: FontWeight.w600,
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
