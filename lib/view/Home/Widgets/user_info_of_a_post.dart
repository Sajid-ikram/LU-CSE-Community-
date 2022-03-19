import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/settings/view_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../public_widget/photo_view.dart';

class UserInfoOfAPost extends StatefulWidget {
  const UserInfoOfAPost(
      {Key? key,
      required this.uid,
      required this.time,
      required this.pageName,
      this.postId})
      : super(key: key);
  final String pageName;
  final String uid;
  final String time;
  final String? postId;

  @override
  _UserInfoOfAPostState createState() => _UserInfoOfAPostState();
}

class _UserInfoOfAPostState extends State<UserInfoOfAPost> {
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

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    if (to.difference(from).inHours > 24) {
      return (to.difference(from).inHours / 24).round().toString() + " day";
    } else if (to.difference(from).inMinutes < 60) {
      return to.difference(from).inMinutes.toString() + " min";
    } else {
      return to.difference(from).inHours.toString() + " hour";
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
                    Text("...h", style: TextStyle(fontSize: 13)),
                  ],
                ),
                const Spacer(),
                if (widget.pageName == "home" && widget.pageName != "notice")
                  Icon(Icons.favorite, size: 20.sp, color: Colors.grey),
              ],
            ),
          )
        : widget.pageName == "home" ||
                widget.pageName == "notice" ||
                widget.pageName == "post"
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomPhotoView(
                          url: data["url"],
                        );
                      }));
                    },
                    child: returnImage(data),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.pageName == "comment") SizedBox(height: 5.h),
                      buildNameText(14),
                      SizedBox(height: 2.h),
                      buildTimeText(),
                    ],
                  ),
                  const Spacer(),
                  if (widget.pageName != "notice" && widget.pageName != "post")
                    FavouriteButton(
                        postId: widget.postId ?? "",
                        pageName: widget.pageName,
                        uid: widget.uid)
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomPhotoView(
                          url: data["url"],
                        );
                      }));
                    },
                    child: returnImage(data),
                  ),
                  SizedBox(width: 12.w),
                  buildNameText(15),
                  SizedBox(width: 10.w),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: buildTimeText(),
                  ),
                ],
              );
  }

  GestureDetector buildNameText(double size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfile(
              uid: data.id,
              isViewer: true,
              batch: data["batch"],
              bio: data["bio"],
              email: data["email"],
              name: data["name"],
              role: data["role"],
              section: data["section"],
              url: data["url"],
              facebook: data["facebook"],
              twitter: data["twitter"],
              linkedin: data["linkedin"],
              github: data["github"],
            ),
          ),
        );
      },
      child: Row(
        children: [
          Text(
            data["name"],
            style: GoogleFonts.inter(
              fontSize: size.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.pageName == "notice" && widget.pageName != "post")
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.star,
                color: const Color(0xffFFCE31),
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }

  Text buildTimeText() {
    return Text(
      daysBetween(DateTime.parse(widget.time), DateTime.now()),
      style: GoogleFonts.inter(
        color: const Color(0xff9e9ea8),
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

Widget returnImage(DocumentSnapshot data) {
  return data["url"] != ""
      ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: NetworkImage(
            data["url"],
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: const AssetImage("assets/profile.jpg"),
        );
}

class FavouriteButton extends StatefulWidget {
  FavouriteButton(
      {Key? key,
      required this.postId,
      required this.pageName,
      required this.uid})
      : super(key: key);
  String pageName;
  String postId;
  String uid;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool contains = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (ctx, providerP, _) {
        contains = Provider.of<ProfileProvider>(context, listen: false)
            .favouritePostIds
            .contains(widget.postId);
        return Consumer<PostProvider>(
          builder: (context, provider, child) {
            return InkWell(
              onTap: () async {
                if (!provider.isLoveLoading) {
                  if (contains) {
                    setState(() {
                      providerP.favouritePostIds.remove(widget.postId);
                      contains = !contains;
                    });
                  } else {
                    setState(() {
                      providerP.favouritePostIds.add(widget.postId);
                      contains = !contains;
                    });
                  }

                  await provider.addToFavourite(
                    postId: widget.postId,
                    uid: providerP.currentUserUid,
                    isExist: !contains,
                    context: context,
                  );
                }
              },
              child: Icon(
                contains ? Icons.favorite : Icons.favorite_outline,
                size: 20.sp,
                color: contains ? Colors.red : Colors.grey,
              ),
            );
          },
        );
      },
    );
  }
}
