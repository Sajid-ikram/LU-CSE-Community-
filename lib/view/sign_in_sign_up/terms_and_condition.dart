import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_cse_community/constant/constant.dart';
import '../public_widget/custom_app_bar.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Terms And Condition", context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 10.h),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      "⚫  ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      termsAndCondition[index],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: termsAndCondition.length,
        ),
      ),
    );
  }
}
