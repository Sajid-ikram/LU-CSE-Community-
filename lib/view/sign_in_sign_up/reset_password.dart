import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_text_field.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/promise.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/top.dart';
import 'package:provider/provider.dart';

import '../public_widget/build_loading.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  void dispose() {
    emailController.clear();
  }

  validate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .resetPassword(emailController.text,context)
            .then(
              (value) {
                Navigator.of(context, rootNavigator: true).pop();
            if (value != "Success") {
              snackBar(context, "Reset password link was sent to your email");
            }
            else{
              snackBar(context, "An error accor");
            }
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: 414.w,
                height: 837.h - statusBarHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 37.w),
                        child: Text(
                          "Reset password",
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
                        padding:
                            EdgeInsets.only(left: 37.w, top: 12.h, bottom: 18.h),
                        child: Text(
                          "Enter the email associated with your account and we'll send an email with instructions to reset your password",
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
                            emailController,
                            "Email Address",
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
                      child: buildButton("Send Instruction", 340, 18,56),
                    ),
                  ],
                ),
              ),
              top(context, "OnBoarding"),
            ],
          ),
        ),
      ),
    );
  }
}
