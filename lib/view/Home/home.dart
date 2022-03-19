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
import '../public_widget/build_loading.dart';
import '../public_widget/photo_view.dart';
import 'Widgets/add_post.dart';
import 'Widgets/react_section.dart';
import 'Widgets/user_info_of_a_post.dart';
import 'Widgets/search_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(user!.uid);
    super.initState();
  }

  int size = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 90.h),
              height: 740.h,
              width: double.infinity,
              child: Selector<PostProvider, bool>(
                selector: (context, provider) => provider.isNewPostAdded,
                builder: (context, provider, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .orderBy('dateTime', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Something went wrong"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildLoading();
                      }

                      final data = snapshot.data;
                      if (data != null) {
                        size = data.size + 1;
                      }
                      return _buildConsumer(data!);
                    },
                  );
                },
              ),
            ),
          ),
          buildSearch(context, "Home"),
        ],
      ),
    );
  }

  Consumer<SearchProvider> _buildConsumer(QuerySnapshot data) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 65.h),
          itemBuilder: (context, index) {
            if (index == 0) {
              return addPost(context);
            }
            String name = data.docs[index - 1]["userName"];
            if (name
                .toLowerCase()
                .contains(provider.searchText.toLowerCase())) {
              return individualPost(index, data.docs[index - 1], context);
            }
            return const SizedBox();
          },
          itemCount: size,
        );
      },
    );
  }
}

Container individualPost(
    int index, DocumentSnapshot data, BuildContext context) {
  return Container(
    width: 350.w,
    margin: EdgeInsets.fromLTRB(32.w, index == 1 ? 15.h : 10.h, 32.w, 10.h),
    padding: EdgeInsets.fromLTRB(21.w, 25.h, 0, 10.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xffE3E3E3), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 15,
        )
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 21.w),
          child: UserInfoOfAPost(
            uid: data["ownerUid"],
            time: data["dateTime"],
            pageName: "home",
            postId: data.id,
          ),
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.only(right: 21.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data["postText"],
              style: GoogleFonts.inter(fontSize: 15.sp, height: 1.4),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        if (data["imageUrl"] != "")
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return CustomPhotoView(
                    url: data["imageUrl"],
                  );
                }),
              );
            },
            child: Container(
              width: 308.w,
              height: 226.h,
              margin: EdgeInsets.only(bottom: 13.h, right: 21.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  data["imageUrl"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ReactSection(
          documentSnapshot: data,
        )
      ],
    ),
  );
}
