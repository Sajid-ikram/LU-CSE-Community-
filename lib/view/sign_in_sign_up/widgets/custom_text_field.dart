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
        if (text == "Enter your name") {
          if (value != null && value.length > 50) {
            snackBar(context, "Name should be less then 50 character");
            return "Name should be less then 50 character";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          } else if (isNameValid(value)) {
            snackBar(context, "Name should contain only character");
            return "Field can not be empty!";
          }
        } else if (text == "Email Address") {
          if (value != null && !value.contains("@lus.ac.bd")) {
            snackBar(context, "You have to use LU G Suite Email");
            return "You have to use LU G Suite Email";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
        } else if (text == "Password") {
          if (value != null && value.length < 6) {
            snackBar(context, "Password should be at least 6 character long");
            return "Password should be at least 6 character long";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
        } else if (text == "Confirm Password") {
          if (value != null && value.length < 6) {
            snackBar(context, "Password should be at least 6 character long");
            return "Password should be at least 6 character long";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          } else if (pro.passwordController.text != value) {
            snackBar(context, "Password does not match");
            return "Password does not match";
          }
        } else if (text == "Batch") {
          if (value != null && value.length > 5) {
            snackBar(context, "Batch should be less then 5 character");
            return "Batch should be less then 5 character";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
        } else if (text == "Section") {
          if (value != null && value.length > 1) {
            snackBar(context, "Section should be 1 character long");
            return "Section should be 1 character long";
          } else if (value == null || value.isEmpty) {
            snackBar(context, "Field can not be empty!");
            return "Field can not be empty!";
          }
        } else if (value == null || value.isEmpty) {
          snackBar(context, "Field can not be empty!");
          return "Field can not be empty!";
        }
        return null;
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

bool isNameValid(String name) {
  if (name.isEmpty) {
    return false;
  }
  bool hasDigits = name.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacters = name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    print( hasDigits & hasSpecialCharacters);
    print( hasDigits);
    print( hasSpecialCharacters);
    print( "*********************hasDigits & hasSpecialCharacters");
  return hasDigits & hasSpecialCharacters;
}
