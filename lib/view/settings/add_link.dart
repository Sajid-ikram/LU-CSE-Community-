import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_text_field.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/promise.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/top.dart';
import 'package:provider/provider.dart';

import '../public_widget/build_loading.dart';
import '../public_widget/custom_app_bar.dart';

class AddLink extends StatefulWidget {
  AddLink({Key? key, required this.iconData, required this.color})
      : super(key: key);
  IconData iconData;
  Color color;

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final TextEditingController linkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    linkController.clear();
  }

  validate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String temp = "";
      if (widget.iconData == FontAwesomeIcons.facebook) {
        temp = "facebook";
        if (!linkController.text.contains("facebook")) {
          snackBar(context, "Not a valid Facebook Link");
          return;
        }
      } else if (widget.iconData == FontAwesomeIcons.twitter) {
        temp = "twitter";
        if (!linkController.text.contains("twitter")) {
          snackBar(context, "Not a valid Twitter Link");
          return;
        }
      } else if (widget.iconData == FontAwesomeIcons.github) {
        temp = "github";
        if (!linkController.text.contains("github")) {
          snackBar(context, "Not a valid Github Link");
          return;
        }
      } else if (widget.iconData == FontAwesomeIcons.linkedinIn) {
        temp = "linkedin";
        if (!linkController.text.contains("linkedin")) {
          snackBar(context, "Not a valid LinkedIn  Link");
          return;
        }
      }
      try {
        buildLoadingIndicator(context);
        Provider.of<ProfileProvider>(context, listen: false)
            .updateSocialLink(context: context,link: linkController.text,site: temp)
            .then(
          (value) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop();
          },
        );
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "An error accor");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: customAppBar("Add Link", context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Icon(
              widget.iconData,
              size: 200.sp,
              color: widget.color,
            ),
            SizedBox(height: 50.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 37.w),
                child: Text(
                  "Add A Link",
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 360.w,
                padding: EdgeInsets.only(left: 37.w, top: 12.h, bottom: 18.h),
                child: Text(
                  "Copy the link of your social media profile and past it on here.",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: mainColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  customTextField(
                    linkController,
                    "Link",
                    false,
                    context,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                validate(context);
              },
              child: buildButton("Save", 340, 18, 56),
            ),
          ],
        ),
      ),
    );
  }
}
