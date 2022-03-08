import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/contest_provider.dart';
import 'package:intl/intl.dart';
import 'package:lu_cse_community/provider/notification_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'error_dialoge.dart';
import 'package:timezone/data/latest.dart' as tz;

Container buildContestWidget({
  required int index,
  required ContestProvider pro,
  required int endTimeForTimer,
  required String site,
  required BuildContext context,
}) {
  return Container(
    width: 350.w,
    margin: EdgeInsets.fromLTRB(20, index == 0 ? 20 : 10,20, 0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12, width: 1),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          spreadRadius: 8,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(22.w, 15.h, 22.w, 8.h),
          child: Row(
            children: [
              Container(
                height: 45.h,
                width: 45.h,
                margin: EdgeInsets.only(right: 20.w),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 9,
                        blurRadius: 9)
                  ],
                ),
                child: Image.asset(
                    "assets/SitesLogo/${site.length > 15 ? pro
                        .individualContestList[index].site : site}.png"),
              ),
              Text(
                site.length > 15 ? pro.individualContestList[index].site : site,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              NotificationButton(index: index, pro: pro, site: site),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.black12,
        ),
        buildText("Name :"),
        Padding(
          padding:
          EdgeInsets.only(left: 30.w, bottom: 10.h, top: 5.h, right: 30.w),
          child: Text(
            pro.individualContestList[index].name,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ),
        buildStartAndEnd(pro, index, "Start"),
        buildStartAndEnd(pro, index, "End"),
        buildStartAndEnd(pro, index, "Duration"),
        Padding(
          padding:
          EdgeInsets.only(left: 0.w, bottom: 3.h, top: 5.h, right: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildText("Start In :"),
              Flexible(
                child: CountdownTimer(
                  textStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: mainColor,
                  ),
                  endTime: endTimeForTimer,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            //_launchURL(pro.individualContestList[index].url, context);
            openUrl(pro.individualContestList[index].url);
          },
          child: Container(
            height: 38.h,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(29.w, 10.h, 29, 17.h),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Open in web",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

class NotificationButton extends StatefulWidget {
  const NotificationButton({
    required this.site,
    required this.pro,
    required this.index,
  });

  final String site;
  final int index;
  final ContestProvider pro;

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    tz.initializeTimeZones();
    getData();
    super.initState();
  }

  bool pressed = false;

  getData() async {
    pressed = await NotificationService().isPressed(
      widget.pro.individualContestList[widget.index].name.hashCode,
    );

    if (pressed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final difference =
        DateTime
            .parse(widget.pro.individualContestList[widget.index].startTime)
            .difference(DateTime.now())
            .inSeconds;
    return InkWell(
      onTap: () async {
        if (pressed) {
          await NotificationService().cancelNotifications(
              widget.pro.individualContestList[widget.index].name.hashCode);

          setState(() {
            pressed = false;
          });
        } else {
          await durationPicker(
            ctx: context,
            name: widget.pro.individualContestList[widget.index].name,
            site: widget.site.length > 15
                ? widget.pro.individualContestList[widget.index].site
                : widget.site,
            remainingTime: difference,
          );

        }
      },
      child: Consumer<NotificationService>(
        builder: (context, provider, child) {
          getData();
          return Icon(
            pressed ? Icons.notifications : Icons.notifications_outlined,
            size: 24.sp,
          );
        },
      ),
    );
  }
}


 Future<bool> openUrl(String url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


Row buildStartAndEnd(ContestProvider pro, int index, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildText("$text :"),
      Padding(
        padding:
        EdgeInsets.only(left: 30.w, bottom: 5.h, top: 5.h, right: 30.w),
        child: Text(
          text == "Duration"
              ? _getDuration(Duration(
              seconds: int.parse(
                  double.parse(pro.individualContestList[index].duration)
                      .round()
                      .toString())))
              : _changeTime(
            DateTime.parse(
              text == "Start"
                  ? pro.individualContestList[index].startTime
                  : pro.individualContestList[index].endTime,
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: mainColor,
          ),
        ),
      )
    ],
  );
}

Padding buildText(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 30.w, bottom: 3.h, top: 5.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xff606060),
      ),
    ),
  );
}

String _getDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

  return "${twoDigits(duration.inHours)} Hour / $twoDigitMinutes Minutes";
}

String _changeTime(DateTime dt) {
  var dateFormat = DateFormat("dd-MM-yyyy hh:mm aa");
  var utcDate = dateFormat.format(DateTime.parse(dt.toString()));
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  return dateFormat.format(DateTime.parse(localDate));
}
