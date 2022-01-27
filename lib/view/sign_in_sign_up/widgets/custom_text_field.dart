import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_cse_community/provider/sign_up_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/promise.dart';
import 'package:provider/provider.dart';

Container customTextField(TextEditingController controller, String text,
    bool isPass, BuildContext context) {
  final pro = Provider.of<SignUpProvider>(context, listen: false);
  return Container(
    height: 50.h,
    width: 340.w,
    margin: EdgeInsets.only(top: 10.h),
    child: TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      validator: (value) {
        if (text == "Email Address") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Enter an email");
            return "show error";
          } else if (!value.contains('@lus.ac.bd')) {
            snackBar(context, "Enter a valid LU G-suite email");
            return "show error";
          } else {
            return null;
          }
        } else if (text == "Password") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Enter a Password");
            return "show error";
          } else if (value.length < 6) {
            snackBar(context, "Password must be greater than 6 digit");
            return "show error";
          } else {
            return null;
          }
        } else if (text == "Confirm Password") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Enter to Confirm Password");
            return "show error";
          } else if (value.length < 6) {
            snackBar(context, "Password must be greater than 6 digit");
            return "show error";
          } else if (value != pro.passwordController.text) {
            snackBar(context, "Password does not match");
            return "show error";
          } else {
            return null;
          }
        }else if (text == "Batch") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Enter your Batch");
            return "show error";
          } else if (value.length > 5) {
            snackBar(context, "Batch should be less then 5 character");
            return "show error";
          } else {
            return null;
          }
        }else if (text == "Section") {
          if (value == null || value.isEmpty) {
            snackBar(context, "Enter your Section");
            return "show error";
          } else if (value.length > 1) {
            snackBar(context, "Section should be 1 character long");
            return "show error";
          } else {
            return null;
          }
        } else {
          if (value == null || value.isEmpty) {
            snackBar(context, "All fields are required!");
            return "show error";
          }
        }
      },
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.emailAddress,
      obscureText: text == "Password"
          ? pro.obscureText
          : text == "Confirm Password"
              ? true
              : false,
      decoration: inputDecoration(isPass, pro, text),
    ),
  );
}

InputDecoration inputDecoration(bool isPass, SignUpProvider pro, String text) {
  return InputDecoration(

    errorStyle:  text == "Change Bio" ||
        text == "Change name" ||
        text == "Change Section" ||
        text == "Change Batch"
        ? null : const TextStyle(fontSize: 0.01),
    suffixIcon: isPass
        ? IconButton(
            onPressed: () {
              pro.changeObscure();
            },
            icon: Icon(
              FontAwesomeIcons.solidEye,
              size: 16.sp,
              color: mainColor,
            ),
          )
        : const SizedBox(),
    contentPadding: EdgeInsets.only(
      left: 25.w,
      top: text == "Change Bio" ? 10 : 0,
      bottom: text == "Change Bio" ? 10 : 0,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: text == "Change Bio" ||
                  text == "Change name" ||
                  text == "Change Section" ||
                  text == "Change Batch"
              ? const Color(0xffE2E2E2)
              : Colors.grey,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: mainColor,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
        )),
    hintText: text,
    hintStyle: GoogleFonts.inter(color: mainColor, fontSize: 15.sp),
  );
}
