import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff294899),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildTop(), _buildGridView()],
        ),
      ),
    );
  }

  Container _buildGridView() {

    List<String> nameList  = [
      "Notice",
      "LUCC",
      "ACM",
      "Users",
      "Routine",
      "Bus Schedule",
    ];

    return Container(
      height: 770.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          topLeft: Radius.circular(35),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            int paddingH = 0, paddingV = 0;
            if (index == 1 || index == 4 || index == 5) {
              paddingV = 25;
              paddingH = 20;
            }

            return SizedBox(
              height: 200.h,
              width: 162.w,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      if(index == 3){
                        Navigator.of(context).pushNamed("AllUsers");
                      }
                    },
                    child: Container(
                      height: 174.h,
                      width: 162.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingH.sp, vertical: paddingV.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xfff7f7f7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        "assets/dashboard/D${index + 1}.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    nameList[index],
                    style: GoogleFonts.inter(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: mainColor,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  SizedBox _buildTop() {
    return SizedBox(
      height: 260.h,
      width: 414.w,
      child: Stack(
        children: [
          Image.asset(
            "assets/bg.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 70.h,
            left: 162.w,
            child: Container(
              height: 88.w,
              width: 88.w,
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Image.asset(
                "assets/lu.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Text(
                "DASHBOARD",
                style: GoogleFonts.inter(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
