import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/post_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddNewPostPage extends StatefulWidget {
  const AddNewPostPage({Key? key}) : super(key: key);

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
      buildShowDialog(context);
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

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: mainColor),
        );
      },
    );
  }

  TextEditingController postController = TextEditingController();

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
                      onTap: () {
                        uploadPost();
                      },
                      child: buildButton("Post", 85, 16, 40))
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
                        border: Border.all(color:Colors.grey.withOpacity(0.4)),
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
