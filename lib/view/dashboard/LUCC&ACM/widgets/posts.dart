import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Home/Widgets/search_bar.dart';
import '../../../Home/Widgets/user_info_of_a_post.dart';
import '../../../public_widget/build_loading.dart';
import 'events.dart';

class Posts extends StatefulWidget {
  Posts({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.name + "Post")
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

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 15.h),
                    buildSearch(context, "Home"),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 32.w, top: 30.h, bottom: 20.h),
                      child: Text(
                        "All Post",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container(
                width: 350.w,
                margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 21.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffE3E3E3), width: 1),
                ),
                child: Column(
                  children: [
                    UserInfoOfAPost(
                      uid: data?.docs[index - 1]["ownerUid"],
                      time: data?.docs[index - 1]["dateTime"],
                      pageName: "post",
                    ),
                    SizedBox(height: 18.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data?.docs[index - 1]["postText"],
                        style: GoogleFonts.inter(fontSize: 15.sp, height: 1.4),
                      ),
                    ),
                    if (data?.docs[index - 1]["imageUrl"] != "")
                      SizedBox(height: 15.h),
                    if (data?.docs[index - 1]["imageUrl"] != "")
                      Container(
                        width: 308.w,
                        height: 226.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            data?.docs[index - 1]["imageUrl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              );

              return const SizedBox();
            },
            itemCount: size + 1,
          );
        },
      ),
    );
  }
}
