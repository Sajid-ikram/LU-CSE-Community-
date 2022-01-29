import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/view/Home/Widgets/user_info_of_a_post.dart';
import 'package:provider/provider.dart';

Future addNewComment(
    {required BuildContext context,
    required String postId,
    required String commentNumber}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => SizedBox(
      height: 620.h,
      child: Column(
        children: [
          Container(
            height: 10.h,
            width: 150.w,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Container(
            height: 600.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                commentSection(context, postId, commentNumber),
                Expanded(
                  //margin: EdgeInsets.all(32.sp),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.sp, vertical: 20.h),
                    child: streamBuilderComment(postId),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

StreamBuilder<QuerySnapshot<Object?>> streamBuilderComment(String postId) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection("thoseWhoComment")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 44.h,
                  child: UserInfoOfAPost(
                    uid: data?.docs[index]["ownerUid"],
                    time: data?.docs[index]["dateTime"],
                    pageName: "comment",
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 0.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data?.docs[index]["commentText"],
                      style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: Colors.black.withOpacity(0.6),
                          height: 1.3),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SizedBox(height: 13.h),
                const Divider(thickness: 1),
                SizedBox(height: 10.h),
              ],
            );
          },
          itemCount: data?.size,
        );
      });
}

Container commentSection(BuildContext context, String postId, String comment) {
  return Container(
    width: 350.w,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.09))),
    child: Column(
      children: [
        Center(
          child: TextField(
            onChanged: (value) {
              Provider.of<PostProvider>(context, listen: false)
                  .changeCommentText(value);
            },
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.7.sp),
              border: InputBorder.none,
              focusColor: mainColor,
              hintText: "Type your comment",
              hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
        ),
        Container(
          height: 50.h,
          width: double.infinity,
          margin: EdgeInsets.all(7.sp),
          decoration: BoxDecoration(
            color: const Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Spacer(),
              Consumer<PostProvider>(
                builder: (context, provider, child) {
                  return GestureDetector(
                    onTap: () {
                      if (provider.commentText.isNotEmpty) {
                        provider.addNewComment(
                            postId: postId,
                            uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                            comment: comment,
                            dateTime: DateTime.now().toString(),
                            context: context);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 40.h,
                      width: 83.w,
                      decoration: BoxDecoration(
                        color: provider.commentText.isEmpty
                            ? const Color(0xffBDBDBD)
                            : mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Send",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 8.w)
            ],
          ),
        )
      ],
    ),
  );
}
