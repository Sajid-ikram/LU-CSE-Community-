import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/Chat/widgets/chat_user_top.dart';
import 'package:provider/provider.dart';

import 'chat.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({Key? key}) : super(key: key);

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            chatTop(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chatRooms")
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
                    if (data != null) {
                      size = data.size;
                      if (size == 0) {
                        return Center(
                          child: Text(
                            "No chat yet!",
                            style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: mainColor),
                          ),
                        );
                      }

                      return buildListOfChat(data);
                    } else {
                      return const Center(child: Text("Something went wrong"));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  ListView buildListOfChat(QuerySnapshot<Object?> data) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);


    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String name = "";
        String url = "";
        String uid = "";
        bool show = false;
        if(data.docs[index]["user1"] == pro.currentUserUid){
          name = data.docs[index]["name2"];
          url = data.docs[index]["url2"];
          uid = data.docs[index]["user2"];
          show = true;
        }else  if(data.docs[index]["user2"] == pro.currentUserUid){
          name = data.docs[index]["name1"];
          url = data.docs[index]["url1"];
          uid = data.docs[index]["user1"];
          show = true;
        }

        return show&&
                data.docs[index]["lastMassage"] != ""
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(
                          name: name, url: url, uid: uid),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildImage(url),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                            width: 250.w,
                            child: Text(
                              data.docs[index]["lastMassage"],
                              overflow: TextOverflow.ellipsis,

                              maxLines: 1,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: const Color(0xff6a6a6a),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),


                        ],
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox();
      },
      itemCount: size,
    );
  }
}

Widget buildImage(String url) {
  return url.isNotEmpty
      ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: NetworkImage(
            url,
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: const AssetImage("assets/profile.jpg"),
        );
}
