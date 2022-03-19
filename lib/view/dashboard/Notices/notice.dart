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
import '../../../provider/notice_provider.dart';
import '../../Home/SubPage/add_new_post_page.dart';
import '../../Home/Widgets/user_info_of_a_post.dart';
import '../../public_widget/build_loading.dart';
import '../../public_widget/custom_app_bar.dart';
import '../../public_widget/floating_action_button.dart';
import '../../public_widget/photo_view.dart';

enum WhyFarther { delete, edit }

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: customAppBar("Notice", context),
      floatingActionButton: pro.role == "Teacher" || pro.role == "Admin"
          ? customFloatingActionButton(context, "Notice")
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<NoticeProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<QuerySnapshot>(
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
                        padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                          Border.all(color: const Color(0xffE3E3E3), width: 1),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                UserInfoOfAPost(
                                  uid: data?.docs[index]["ownerUid"],
                                  time: data?.docs[index]["dateTime"],
                                  pageName: "notice",
                                ),
                                if (pro.currentUserUid ==
                                    data?.docs[index]["ownerUid"])
                                  Positioned(
                                    right: 0,
                                    child: PopupMenuButton<WhyFarther>(
                                      icon: const Icon(Icons.more_horiz),
                                      padding: EdgeInsets.zero,
                                      onSelected: (WhyFarther result) {
                                        if (result == WhyFarther.delete) {
                                          _showMyDialog(
                                              context,
                                              data?.docs[index].id ?? "");
                                        } else if (result == WhyFarther.edit) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewPostPage(
                                                    page: "Home",
                                                    documentSnapshot: data
                                                        ?.docs[index],
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
                            SizedBox(height: 18.h),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data?.docs[index]["postText"],
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp, height: 1.4),
                                ),
                              ),
                            ),
                            if (data?.docs[index]["imageUrl"] != "")
                              SizedBox(height: 15.h),
                            if (data?.docs[index]["imageUrl"] != "")
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return CustomPhotoView(
                                        url: data?.docs[index]["imageUrl"],
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 226.h,
                                  padding: EdgeInsets.only(right: 15.w),
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
                              ),
                          ],
                        ),
                      );
                    },
                    itemCount: size,
                  );
                },
              );
            },
          )),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String id) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Notice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to delete this notice'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<NoticeProvider>(context, listen: false)
                  .deleteNotice(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
