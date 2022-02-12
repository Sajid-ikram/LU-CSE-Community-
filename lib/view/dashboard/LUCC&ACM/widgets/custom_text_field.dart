import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constant/constant.dart';

Container buildCustomTextField(String text, String hint,
    TextEditingController controller, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
    width: 400.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != "post")
          Text(
            text,
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600),
          ),
        SizedBox(height: 10.h),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.justify,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field can not be empty!";
            }
            return null;
          },
          enabled: text == "Event Schedule" ? false : true,
          minLines: text == "post"
              ? 8
              : text == "Event Description"
                  ? 4
                  : 1,
          maxLines: 10,
          maxLength: text == "post" || text == "Event Description" ? 500 : null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorStyle: GoogleFonts.inter(fontSize: 0.01),
            suffixIcon: text == "Event Schedule"
                ? const Icon(Icons.keyboard_arrow_down)
                : null,
            contentPadding: EdgeInsets.only(
              left: 16.w,
              top: 16,
              bottom: 10,
              right: 10.w
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.inter(
                color: Colors.grey.withOpacity(0.5), fontSize: 15.sp),
          ),
        )
      ],
    ),
  );
}



