import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/chat_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../chat.dart';

class IndividualChatInfo extends StatefulWidget {
  const IndividualChatInfo({Key? key, required this.uid, required this.lastMs})
      : super(key: key);
  final String lastMs;
  final String uid;

  @override
  _IndividualChatInfoState createState() => _IndividualChatInfoState();
}

class _IndividualChatInfoState extends State<IndividualChatInfo> {
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
                    Text("............", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          )
        : InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Chat(name: data["name"], url: data["url"], uid: data.id),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                returnImage(data),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNameText(),
                    SizedBox(height: 2.h),
                    buildLastText(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
  }

  Text buildNameText() {
    return Text(
      data["name"],
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  SizedBox buildLastText() {
    return SizedBox(
      height: 20.h,
      width: 250.w,
      child: Text(
        ChatProvider.decrypt(widget.lastMs),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: const Color(0xff6a6a6a),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

Widget returnImage(DocumentSnapshot data) {
  return data["url"] != ""
      ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 22.sp,
          backgroundImage: NetworkImage(
            data["url"],
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 22.sp,
          backgroundImage: const AssetImage("assets/profile.jpg"),
        );
}
