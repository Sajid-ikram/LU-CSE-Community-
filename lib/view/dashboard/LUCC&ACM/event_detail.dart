import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/dashboard/LUCC&ACM/widgets/events.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import 'package:intl/intl.dart';
import '../../../provider/notice_provider.dart';
import '../../../provider/profile_provider.dart';
import 'add_new_event_or_post.dart';

enum WhyFarther { delete, edit }

class EventDetail extends StatefulWidget {
  EventDetail({Key? key, required this.data, required this.pageName})
      : super(key: key);
  QueryDocumentSnapshot? data;
  String pageName;

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 320.h,
              width: double.infinity,
              child: widget.data!["url"] == ""
                  ? Image.asset(
                      "assets/event.png",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.data!["url"],
                      fit: BoxFit.cover,
                    ),
            ),
            Column(
              children: [
                SizedBox(height: 280.h),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.sp),
                          topRight: Radius.circular(40.sp))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Align(
                        child: Container(
                          height: 4.h,
                          width: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2.sp),
                              topRight: Radius.circular(2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 10.h),
                        child: Text(
                          widget.data!["title"],
                          style: GoogleFonts.inter(
                            color: mainColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 30.w,
                        endIndent: 30.w,
                        thickness: 0.4,
                        color: mainColor.withOpacity(0.3),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
                        child: Text(
                          "Description : ",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.inter(
                            color: mainColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 10.h),
                        child: Text(
                          widget.data!["description"],
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.inter(
                            color: const Color(0xff555555),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 10.h),
                        child: _buildRow(FontAwesomeIcons.mapMarkerAlt,
                            widget.data!["place"], "Location"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 10.h),
                        child: _buildRow(
                          FontAwesomeIcons.clock,
                          _changeTime(DateTime.parse(widget.data!["schedule"])),
                          "Date",
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 45.h,
              left: 30.w,
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: buildContainerIcon(Icons.close)),
            ),
            if (pro.currentUserUid == widget.data!["ownerUid"])
              Positioned(
                top: 45.h,
                right: 30.w,
                child: PopupMenuButton<WhyFarther>(
                  icon: buildContainerIcon(Icons.more_horiz),
                  padding: EdgeInsets.zero,
                  onSelected: (WhyFarther result) async {
                    if (result == WhyFarther.delete) {
                      await _showMyDialog(
                          context, widget.data!.id, widget.pageName + "Event");
                      Navigator.of(context).pop();
                    } else if (result == WhyFarther.edit) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewPostOrEvent(
                            pageName: widget.pageName,
                            type: "Event",
                            documentSnapshot: widget.data!,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.delete,
                      child: Text('Delete'),
                    ),
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.edit,
                      child: Text('Edit'),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Row _buildRow(IconData iconData, String title, String place) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            height: 45.w,
            width: 45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xffFFF1EA),
            ),
            child: Icon(
              iconData,
              color: const Color(0xffF57739),
              size: 22.sp,
            )),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place,
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp),
            ),
          ],
        )
      ],
    );
  }

  Container buildContainerIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.all(3.sp),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 5)
          ]),
      child: Icon(
        iconData,
        size: 22.sp,
      ),
    );
  }

  Padding buildInfoRow(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 6.h),
      child: Row(
        children: [
          Text(
            text1,
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
              color: mainColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              text2,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                color: mainColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _changeTime(DateTime dt) {
  var dateFormat = DateFormat("dd-MM-yyyy");
  var utcDate = dateFormat.format(DateTime.parse(dt.toString()));
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  return dateFormat.format(DateTime.parse(localDate));
}

Future<void> _showMyDialog(
    BuildContext context, String id, String whichPost) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Post'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to delete this event'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<NoticeProvider>(context, listen: false)
                  .deleteEvent(id, whichPost);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
