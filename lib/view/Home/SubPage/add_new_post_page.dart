import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../provider/notice_provider.dart';
import '../../../provider/pdf_provider.dart';
import '../../public_widget/build_loading.dart';

class AddNewPostPage extends StatefulWidget {
  AddNewPostPage({Key? key, required this.page, this.documentSnapshot})
      : super(key: key);
  String page;
  DocumentSnapshot? documentSnapshot;

  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;

  Future pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          isSelected = true;
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  Future uploadPost() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("postImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      var pro = Provider.of<ProfileProvider>(context, listen: false);
      Provider.of<PostProvider>(context, listen: false).addNewPost(
          userName: pro.profileName,
          profileUrl: pro.profileUrl,
          postText: postController.text,
          imageUrl: url,
          dateTime: DateTime.now().toString(),
          context: context);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updatePost() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("postImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      if (!isSelected &&
          widget.documentSnapshot != null &&
          widget.documentSnapshot!["imageUrl"] != "") {
        url = widget.documentSnapshot!["imageUrl"];
      }

      Provider.of<PostProvider>(context, listen: false).updatePost(
        postText: postController.text,
        id: widget.documentSnapshot!.id,
        imageUrl: url,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future uploadNotice() async {
    try {
      var pdfPro = Provider.of<PDFProvider>(context, listen: false);
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("noticeImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      Provider.of<NoticeProvider>(context, listen: false)
          .addNewNotice(
            postText: postController.text,
            imageUrl: url,
            dateTime: DateTime.now().toString(),
            context: context,
          )
          .then((value) => {
                pdfPro.sendNotification(
                  ["fab732a6-8371-11ec-9974-d6a81ba95cb1"],
                  "There is a new notice",
                  "CSE Department",
                  "https://firebasestorage.googleapis.com/v0/b/lu-cse-community.appspot.com/o/notification%2Flu.png?alt=media&token=8ba2b183-49af-4673-a519-020fa1f3ca74",
                )
              });
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updateNotice() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("noticeImage/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      if (!isSelected &&
          widget.documentSnapshot != null &&
          widget.documentSnapshot!["imageUrl"] != "") {
        url = widget.documentSnapshot!["imageUrl"];
      }

      Provider.of<NoticeProvider>(context, listen: false).updateNotice(
        postText: postController.text,
        id: widget.documentSnapshot!.id,
        imageUrl: url,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  late TextEditingController postController;

  @override
  void initState() {
    if (widget.documentSnapshot != null) {
      postController =
          TextEditingController(text: widget.documentSnapshot!["postText"]);
    } else {
      postController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30.sp,
                      )),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (widget.page == "Home") {
                          if (widget.documentSnapshot == null) {
                            uploadPost();
                          } else {
                            updatePost();
                          }
                        } else {
                          if (widget.documentSnapshot == null) {
                            uploadNotice();
                          } else {
                            updateNotice();
                          }
                        }
                      },
                      child: buildButton(
                        widget.documentSnapshot == null ? "Post" : "Update",
                        90,
                        16,
                        40,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
              child: TextField(
                maxLines: 12,
                style: const TextStyle(color: Colors.black),
                controller: postController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type something...",
                  hintStyle: GoogleFonts.inter(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 20.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 70.h,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(FontAwesomeIcons.cameraRetro),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Container(
                    height: 70.h,
                    width: 78.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isSelected
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                            ))
                        : widget.documentSnapshot != null &&
                                widget.documentSnapshot!["imageUrl"] != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.documentSnapshot!["imageUrl"],
                                  fit: BoxFit.cover,
                                ))
                            : const Icon(
                                FontAwesomeIcons.image,
                              ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildTitleText(String text, double size, double height) {
  return Container(
    alignment: Alignment.centerLeft,
    width: 220,
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Color(0xffFCCFA8), fontSize: size),
    ),
  );
}
