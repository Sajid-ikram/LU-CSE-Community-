import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/provider/search_provider.dart';
import 'package:provider/provider.dart';
import '../../Home/Widgets/user_info_of_a_post.dart';
import '../../public_widget/build_loading.dart';
import '../../public_widget/custom_app_bar.dart';
import '../../public_widget/floating_action_button.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: customAppBar("Notice", context),
      floatingActionButton: pro.role == "Teacher" || pro.role == "Admin"
          ? customFloatingActionButton(context,"Notice")
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("notice")
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
                itemBuilder: (context, index) {
                  return Container(
                    width: 350.w,
                    margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 21.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xffE3E3E3), width: 1),
                    ),
                    child: Column(
                      children: [
                        UserInfoOfAPost(
                          uid: data?.docs[index]["ownerUid"],
                          time: data?.docs[index]["dateTime"],
                          pageName: "notice",
                        ),
                        SizedBox(height: 18.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data?.docs[index]["postText"],
                            style:
                                GoogleFonts.inter(fontSize: 15.sp, height: 1.4),
                          ),
                        ),
                        if (data?.docs[index]["imageUrl"] != "")
                          SizedBox(height: 15.h),
                        if (data?.docs[index]["imageUrl"] != "")
                          Container(
                            width: 308.w,
                            height: 226.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                data?.docs[index]["imageUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );

                  return const SizedBox();
                },
                itemCount: size,
              );
            },
          )),
    );
  }
}
