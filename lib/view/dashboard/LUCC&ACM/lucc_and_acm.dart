import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/dashboard/LUCC&ACM/widgets/events.dart';
import 'package:lu_cse_community/view/dashboard/LUCC&ACM/widgets/posts.dart';
import '../../../provider/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../public_widget/floating_action_button.dart';

class LUCC_And_ACM extends StatefulWidget {
  LUCC_And_ACM({Key? key, required this.page}) : super(key: key);
  String page;

  @override
  State<LUCC_And_ACM> createState() => _LUCC_And_ACMState();
}

class _LUCC_And_ACMState extends State<LUCC_And_ACM> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context);
    return Scaffold(
      floatingActionButton: pro.role != "Student" && pro.role != "TeacherP"
          ? customFloatingActionButton(context, widget.page)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SizedBox(
        width: 414.w,
        height: 837.h,
        child: Stack(
          children: [
            Container(
              height: 180.h,
              width: 414.w,
              decoration: BoxDecoration(
                color: dashboardColor,
                image: const DecorationImage(
                    image: AssetImage("assets/appbar.png"), fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35.sp),
                  bottomLeft: Radius.circular(35.sp),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 90.h),
                Events(page: widget.page),
                Posts(name: widget.page),
              ],
            ),
            Positioned(
              top: 30.h,
              left: 23.w,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
