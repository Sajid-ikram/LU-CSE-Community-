import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/dashboard/LUCC&ACM/widgets/custom_text_field.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../provider/notice_provider.dart';
import '../../../provider/pdf_and_notification_provider.dart';
import '../../public_widget/build_loading.dart';
import 'package:intl/intl.dart';

class AddNewPostOrEvent extends StatefulWidget {
  AddNewPostOrEvent(
      {Key? key, required this.pageName, this.type, this.documentSnapshot})
      : super(key: key);
  String pageName;
  String? type;
  QueryDocumentSnapshot? documentSnapshot;

  @override
  _AddNewPostOrEventState createState() => _AddNewPostOrEventState();
}

class _AddNewPostOrEventState extends State<AddNewPostOrEvent> {
  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;
  String page = "post";
  final _postFormKey = GlobalKey<FormState>();
  final _eventFormKey = GlobalKey<FormState>();

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
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future uploadEvent() async {
    if (_eventFormKey.currentState!.validate()) {
      try {
        var pdfPro = Provider.of<PDFAndNotificationProvider>(context, listen: false);
        buildLoadingIndicator(context);
        String url = "";
        if (isSelected) {
          final ref = storage.FirebaseStorage.instance
              .ref()
              .child("${widget.pageName}/${DateTime.now()}");

          final result = await ref.putFile(_imageFile);
          url = await result.ref.getDownloadURL();
        }

        Provider.of<NoticeProvider>(context, listen: false)
            .addEvent(
              title: titleController.text,
              description: descriptionController.text,
              place: placeController.text,
              schedule: dateTime.toString(),
              url: url,
              context: context,
              name: widget.pageName,
            )
            .then((value) => {
                  pdfPro.sendNotification(
                    ["fab732a6-8371-11ec-9974-d6a81ba95cb1"],
                    "There is a new event",
                    widget.pageName,
                    "https://firebasestorage.googleapis.com/v0/b/lu-cse-community.appspot.com/o/notification%2Flu.png?alt=media&token=8ba2b183-49af-4673-a519-020fa1f3ca74",
                  )
                });
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future uploadPost() async {
    if (_postFormKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        String url = "";
        if (isSelected) {
          final ref = storage.FirebaseStorage.instance
              .ref()
              .child("${widget.pageName}/${DateTime.now()}");

          final result = await ref.putFile(_imageFile);
          url = await result.ref.getDownloadURL();
        }

        Provider.of<NoticeProvider>(context, listen: false).addPost(
          postText: postController.text,
          imageUrl: url,
          dateTime: DateTime.now().toString(),
          context: context,
          name: widget.pageName,
        );
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future updatePost() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("${widget.pageName}/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      if (!isSelected &&
          widget.documentSnapshot != null &&
          widget.documentSnapshot!["imageUrl"] != "") {
        url = widget.documentSnapshot!["imageUrl"];
      }

      await Provider.of<NoticeProvider>(context, listen: false).updatePost(
        name: widget.pageName,
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

  Future updateEvent() async {
    try {
      buildLoadingIndicator(context);
      String url = "";
      if (isSelected) {
        final ref = storage.FirebaseStorage.instance
            .ref()
            .child("${widget.pageName}/${DateTime.now()}");

        final result = await ref.putFile(_imageFile);
        url = await result.ref.getDownloadURL();
      }

      if (!isSelected &&
          widget.documentSnapshot != null &&
          widget.documentSnapshot!["url"] != "") {
        url = widget.documentSnapshot!["url"];
      }

      await Provider.of<NoticeProvider>(context, listen: false).updateEvent(
        title: titleController.text,
        id: widget.documentSnapshot!.id,
        description: descriptionController.text,
        place: placeController.text,
        schedule: dateTime.toString(),
        url: url,
        context: context,
        name: widget.pageName,
      );

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController temp = TextEditingController();
  DateTime? dateTime;

  @override
  void dispose() {
    titleController.dispose();
    placeController.dispose();
    descriptionController.dispose();
    postController.dispose();
    temp.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.type != null) {
      if (widget.type == "Post") {
        postController.text = widget.documentSnapshot!["postText"];
      } else {
        page = "event";
        titleController.text = widget.documentSnapshot!["title"];
        placeController.text = widget.documentSnapshot!["place"];
        descriptionController.text = widget.documentSnapshot!["description"];
        dateTime = widget.documentSnapshot!["dateTime"].toDate();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 414.w,
        height: 837.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 60.h),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 30.sp,
                  ),
                ),
              ),
              if (widget.type == null) SizedBox(height: 25.h),
              if (widget.type == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          page = "post";
                        });
                      },
                      child: _buildButton("Post", page == "post"),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          page = "event";
                        });
                      },
                      child: _buildButton("Event", page == "event"),
                    ),
                  ],
                ),
              SizedBox(height: 40.h),
              if (page == "event")
                Form(
                  key: _eventFormKey,
                  child: Column(
                    children: [
                      buildCustomTextField("Event Title", "Enter Title.....",
                          titleController, context),
                      GestureDetector(
                        onTap: () async {
                          dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));

                          if (dateTime != null) {
                            temp.text = _changeTime(dateTime!);
                            setState(() {});
                          }
                        },
                        child: buildCustomTextField(
                            "Event Schedule",
                            dateTime == null
                                ? "Enter Schedule ....."
                                : _changeTime(dateTime!),
                            temp,
                            context),
                      ),
                      buildCustomTextField("Event Place", "Enter Place.....",
                          placeController, context),
                      buildCustomTextField(
                          "Event Description",
                          "Type Description.....",
                          descriptionController,
                          context),
                    ],
                  ),
                ),
              Form(
                key: _postFormKey,
                child: Column(
                  children: [
                    if (page == "post")
                      buildCustomTextField("post", "Type something.....",
                          postController, context),
                  ],
                ),
              ),
              buildImageSection(),
              SizedBox(height: 30.h),
              InkWell(
                onTap: () async {
                  if (page == "post") {
                    if (widget.type != null) {
                      updatePost();
                    } else {
                      uploadPost();
                    }
                  } else {
                    if (widget.type != null) {
                      await updateEvent();
                      Navigator.of(context).pop();
                    } else {
                      uploadEvent();
                    }
                  }
                },
                child: buildButton(
                    widget.type != null ? "Update" : "Post", 350, 18, 56),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildImageSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
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
                        widget.type == "Post" &&
                        widget.documentSnapshot!["imageUrl"] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.documentSnapshot!["imageUrl"],
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.documentSnapshot != null &&
                            widget.documentSnapshot!["url"] != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.documentSnapshot!["url"],
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            FontAwesomeIcons.image,
                          ),
          )
        ],
      ),
    );
  }
}

Container _buildButton(String text, bool showBorder) {
  return Container(
    height: 60.h,
    width: 165.w,
    decoration: BoxDecoration(
      color: showBorder ? dashboardColor : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          color: showBorder ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

String _changeTime(DateTime dt) {
  var dateFormat = DateFormat("dd-MM-yyyy");
  var utcDate = dateFormat.format(DateTime.parse(dt.toString()));
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  return dateFormat.format(DateTime.parse(localDate));
}
