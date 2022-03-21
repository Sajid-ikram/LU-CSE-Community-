import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../Home/home.dart';

class FavouritePostList extends StatefulWidget {
  FavouritePostList({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<FavouritePostList> createState() => _FavouritePostListState();
}

class _FavouritePostListState extends State<FavouritePostList> {
  late DocumentSnapshot data;
  bool isLoading = true;
  bool isAvailable = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    data = (await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.id)
        .get());

    if (!data.exists) {
      isAvailable = false;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.grey.withOpacity(0.2),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 350.w,
              height: 250.h,
            ),
          )
        : isAvailable
            ? Consumer<PostProvider>(
                builder: (context, provider, child) {
                  return individualPost(2, data, context);
                },
              )
            : const SizedBox();
  }
}
