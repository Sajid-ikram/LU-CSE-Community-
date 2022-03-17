import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/view/dashboard/LUCC&ACM/event_detail.dart';

import '../../../../constant/constant.dart';
import '../../../public_widget/build_loading.dart';

class Events extends StatefulWidget {
  Events({Key? key, required this.page}) : super(key: key);
  String page;

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: 414.w,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.page + "Event")
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoading();
          }

          final data = snapshot.data;

          if (data != null) {
            size = data.size;
          }

          if (size == 0) {
            return Container(
              width: 257.w,
              margin: EdgeInsets.fromLTRB(32.w, 30.h, 32.w, 30.h),
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  "No Event Available",
                  style: GoogleFonts.inter(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp),
                ),
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DateTime date = DateTime.parse(data?.docs[index]["schedule"]);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventDetail(
                          data: data?.docs[index],
                          pageName: widget.page,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: 257.w,
                  margin: EdgeInsets.fromLTRB(
                      index == 0 ? 32.w : 10.w, 10.h, 10.w, 10.h),
                  /*padding: EdgeInsets.symmetric(
                              vertical: 25.h, horizontal: 21.w),*/
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 147.h,
                        width: 257.w,
                        child: data?.docs[index]["url"] == ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/event.png",
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data?.docs[index]["url"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      SizedBox(height: 20.h),
                      buildRow(date, data?.docs[index]["title"],
                          data?.docs[index]["place"])
                    ],
                  ),
                ),
              );
            },
            itemCount: size,
          );
        },
      ),
    );
  }
}

Row buildRow(DateTime date, String title, String place) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 45.w,
        width: 45.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffF2F6FF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              months[date.month - 1],
              style: GoogleFonts.inter(
                  color: dashboardColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp),
            ),
            Text(
              date.day.toString(),
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp),
            ),
          ],
        ),
      ),
      SizedBox(width: 15.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " " + title,
            style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18.sp,
                color: dashboardColor,
              ),
              Text(
                place,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
