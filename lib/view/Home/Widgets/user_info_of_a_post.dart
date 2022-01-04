import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoOfAPost extends StatefulWidget {
  const UserInfoOfAPost({Key? key, required this.uid, required this.time})
      : super(key: key);
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
    from = DateTime(from.year, from.month, from.day, from.hour,from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour,to.minute);
    if (to.difference(from).inHours > 24) {
      return (to.difference(from).inHours / 24).round().toString() + "d";
    } else if (to.difference(from).inMinutes < 60) {
      return to.difference(from).inMinutes.toString() + "m";
    } else {
      return to.difference(from).inHours.toString() + "h";
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
                const CircleAvatar(backgroundColor: Colors.grey, radius: 20),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("User name", style: TextStyle(fontSize: 14)),
                    Text("...h", style: TextStyle(fontSize: 13)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.favorite, size: 20.sp, color: Colors.grey),
              ],
            ),
          )
        : Row(
            children: [
              data["url"] != ""
                  ? CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: NetworkImage(
                        data["url"],
                      ),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"],
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    daysBetween(DateTime.parse(widget.time), DateTime.now()),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.favorite,
                size: 20.sp,
                color: Colors.red,
              ),
            ],
          );
  }
}
