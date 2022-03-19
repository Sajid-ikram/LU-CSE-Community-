import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../SubPage/add_new_post_page.dart';
import 'add_new_comment.dart';

enum WhyFarther { delete, edit, report }

class ReactSection extends StatefulWidget {
  ReactSection({Key? key, required this.documentSnapshot}) : super(key: key);
  DocumentSnapshot? documentSnapshot;

  @override
  _ReactSectionState createState() => _ReactSectionState();
}

class _ReactSectionState extends State<ReactSection> {
  bool isLiked = false;
  bool isLoading = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    if (widget.documentSnapshot != null) {
      isLiked = await Provider.of<PostProvider>(context, listen: false)
          .isAlreadyLiked(
        postId: widget.documentSnapshot?.id ?? "",
        uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      );
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey,
            child: SizedBox(height: 30, width: 350.w))
        : Row(
            children: [
              buildReactButton("Like", widget.documentSnapshot),
              buildText(widget.documentSnapshot!["likes"]),
              buildReactButton("Comment", widget.documentSnapshot),
              buildText(widget.documentSnapshot!["comments"]),
              //buildReactButton("Share", widget.documentSnapshot),
              const Spacer(),
              SizedBox(
                height: 40.h,
                width: 1,
              ),
              if (pro.role == "Teacher" ||
                  pro.role == "Admin" ||
                  widget.documentSnapshot!["ownerUid"] == pro.currentUserUid)
                PopupMenuButton<WhyFarther>(
                  padding: EdgeInsets.zero,
                  onSelected: (WhyFarther result) {
                    if (result == WhyFarther.delete) {
                      _showMyDialog(context, widget.documentSnapshot!.id);
                    } else if (result == WhyFarther.edit) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewPostPage(
                            page: "Home",
                            documentSnapshot: widget.documentSnapshot,
                          ),
                        ),
                      );
                    } else if (result == WhyFarther.report) {
                      print(result);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.delete,
                      child: Text('Delete'),
                    ),
                    if (widget.documentSnapshot!["ownerUid"] ==
                        pro.currentUserUid)
                      const PopupMenuItem<WhyFarther>(
                        value: WhyFarther.edit,
                        child: Text('Edit'),
                      ),

                    /*const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.report,
                      child: Text('Report'),
                    ),*/
                  ],
                )
            ],
          );
  }

  Padding buildText(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 22.w),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Consumer buildReactButton(String name, DocumentSnapshot? data) {
    var pro = Provider.of<PostProvider>(context, listen: false);
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: InkWell(
            onTap: () async {
              if (!provider.isLoading) {
                if (name == "Like" && data != null) {
                  isLiked = !isLiked;
                  pro.likeAPost(
                    postId: data.id,
                    uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                    likes: data["likes"] ?? "",
                    context: context,
                  );
                } else if (name == "Comment" && data != null) {
                  await addNewComment(
                      context: context,
                      postId: data.id,
                      commentNumber: data["comments"]);
                }
              }
            },
            child: SizedBox(
              height: 20.h,
              width: 20.h,
              child: name == "Like"
                  ? Icon(
                      isLiked
                          ? FontAwesomeIcons.solidThumbsUp
                          : FontAwesomeIcons.thumbsUp,
                      size: 17.sp,
                      color: isLiked ? Colors.blue : Colors.grey,
                    )
                  : SvgPicture.asset(
                      "assets/svg/$name.svg",
                      semanticsLabel: 'A red up arrow',
                      color: name != "Like"
                          ? Colors.grey
                          : isLiked
                              ? Colors.blue
                              : Colors.grey,
                    ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String id) async {
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
              Provider.of<PostProvider>(context, listen: false).deletePost(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
