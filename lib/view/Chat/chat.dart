import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/chat_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/Chat/widgets/build_all_chats.dart';
import 'package:lu_cse_community/view/Chat/widgets/build_chat_top.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key, required this.name, required this.url, required this.uid})
      : super(key: key);

  final String name;
  final String url;
  final String uid;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    var pro = Provider.of<ChatProvider>(context, listen: false);
    var pro2 = Provider.of<ProfileProvider>(context, listen: false);
    pro.createChatRoom(pro2.currentUserUid, widget.uid, pro2.profileUrl,
        widget.url, pro2.profileName, widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60.h),
          buildChatTop(context, widget.name, widget.url),
          buildAllChats(pro, widget.uid),
          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 20.h),
                height: 60.h,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: mainColor, shape: BoxShape.circle),
                      height: 53.w,
                      width: 53.w,
                      child: Icon(
                        Icons.add,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      height: 53.w,
                      width: 280.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: GoogleFonts.inter(color: Colors.black),
                              controller: _controller,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                provider.addMessage(
                                  message: _controller.text,
                                  myUid: pro.currentUserUid,
                                  receiverUid: widget.uid,
                                );
                                _controller.clear();
                              }
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: const Icon(
                              FontAwesomeIcons.paperPlane,
                              color: mainColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
