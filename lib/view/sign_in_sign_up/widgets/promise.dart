import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Row buildPromise(int size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildDot(),
      Text(
        "A PROMISE TO LEAD",
        style: TextStyle(
            fontSize: size.sp,
            color: const Color(0xff151238).withOpacity(0.7),
            fontWeight: FontWeight.w500),
      ),
      buildDot(),
    ],
  );
}

Container buildDot() {
  return Container(
    height: 5.h,
    width: 5.w,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xff151238).withOpacity(0.7),
    ),
  );
}

snackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
