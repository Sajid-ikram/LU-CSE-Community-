import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import '../../../constant/constant.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  EventDetail({Key? key, required this.data}) : super(key: key);
  QueryDocumentSnapshot? data;

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 250.h,
                width: double.infinity,
                child: widget.data!["url"] == ""
                    ? Image.asset(
                        "assets/event.png",
                        fit: BoxFit.fill,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.data!["url"],
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  widget.data!["title"],
                  style: GoogleFonts.inter(
                    color: mainColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                indent: 30.w,
                endIndent: 30.w,
                thickness: 0.3,
                color: mainColor,
              ),
              SizedBox(height: 10.h),
              buildInfoRow("Time : ",
                  _changeTime(DateTime.parse(widget.data!["schedule"]))),
              buildInfoRow("Place : ", widget.data!["place"]),
              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
                child: Text(
                  "Description : ",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    color: mainColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  widget.data!["description"],
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
          Positioned(
            top: 45.h,
            left: 30.w,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(3.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 22.sp,
                  ),
                )),
          )
        ],
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
  var dateFormat = DateFormat("dd-MM-yyyy hh:mm aa");
  var utcDate = dateFormat.format(DateTime.parse(dt.toString()));
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  return dateFormat.format(DateTime.parse(localDate));
}
