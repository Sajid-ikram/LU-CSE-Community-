import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
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
      style: GoogleFonts.inter(color: Colors.black),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          snackBar(context, "Enter an email");
          return "show error";
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
    errorStyle: GoogleFonts.inter(fontSize: 0.01),
    contentPadding: EdgeInsets.only(
      left: 25.w,
      top: text == "Change Bio" ? 10 : 0,
      bottom: text == "Change Bio" ? 10 : 0,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
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
