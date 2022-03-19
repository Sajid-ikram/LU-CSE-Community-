import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/provider/search_provider.dart';
import 'package:provider/provider.dart';
import '../../../../provider/notice_provider.dart';
import '../../../Home/Widgets/search_bar.dart';
import '../../../Home/Widgets/user_info_of_a_post.dart';
import '../../../public_widget/build_loading.dart';
import '../../../public_widget/photo_view.dart';
import '../add_new_event_or_post.dart';
import 'events.dart';

enum WhyFarther { delete, edit }

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
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return Expanded(
      child: Consumer<NoticeProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<QuerySnapshot>(
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

              return Consumer<SearchProvider>(
                builder: (_, providerS, __) {
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
                            buildSearch(context, "LUCC_ACM"),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 32.w, top: 30.h, bottom: 20.h),
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

                      if (data?.docs[index - 1]["postText"]
                          .toLowerCase()
                          .contains(
                              providerS.searchLUCCAndACMPost.toLowerCase())) {
                        return Container(
                          width: 350.w,
                          margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 25.h, horizontal: 21.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xffE3E3E3), width: 1),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  UserInfoOfAPost(
                                    uid: data?.docs[index - 1]["ownerUid"],
                                    time: data?.docs[index - 1]["dateTime"],
                                    pageName: "post",
                                  ),
                                  if (pro.currentUserUid ==
                                      data?.docs[index - 1]["ownerUid"])
                                    Positioned(
                                      right: 0,
                                      child: PopupMenuButton<WhyFarther>(
                                        icon: const Icon(Icons.more_horiz),
                                        padding: EdgeInsets.zero,
                                        onSelected: (WhyFarther result) {
                                          if (result == WhyFarther.delete) {
                                            _showMyDialog(
                                                context,
                                                data?.docs[index - 1].id ?? "",
                                                widget.name + "Post");
                                          } else if (result ==
                                              WhyFarther.edit) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddNewPostOrEvent(
                                                  pageName: widget.name,
                                                  type: "Post",
                                                  documentSnapshot:
                                                      data?.docs[index - 1],
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data?.docs[index - 1]["postText"],
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp, height: 1.4),
                                ),
                              ),
                              if (data?.docs[index - 1]["imageUrl"] != "")
                                SizedBox(height: 15.h),
                              if (data?.docs[index - 1]["imageUrl"] != "")
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CustomPhotoView(
                                          url: data?.docs[index - 1]["imageUrl"],
                                        );
                                      }),
                                    );
                                  },
                                  child: Container(
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
                                ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                    itemCount: size + 1,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
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
              Text('Do you want to delete this post'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<NoticeProvider>(context, listen: false)
                  .deletePost(id, whichPost);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
