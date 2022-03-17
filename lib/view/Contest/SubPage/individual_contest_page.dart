import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/contest_provider.dart';
import 'package:provider/provider.dart';
import '../../public_widget/build_loading.dart';
import 'SubWidgets/build_contest_widget.dart';

class IndividualContestPage extends StatefulWidget {
  const IndividualContestPage({Key? key, required this.site}) : super(key: key);
  final String site;

  @override
  State<IndividualContestPage> createState() => _IndividualContestPageState();
}

class _IndividualContestPageState extends State<IndividualContestPage> {
  bool isLoading = true;
  bool isContestAvailable = false;

  getContestList() async {
    if (widget.site.length > 15) {
      await Provider.of<ContestProvider>(context, listen: false)
          .getAllContest(widget.site, context);
    } else {
      await Provider.of<ContestProvider>(context, listen: false)
          .getIndividualContest(widget.site, context);
    }

    if (Provider.of<ContestProvider>(context, listen: false)
        .individualContestList
        .isEmpty) {
      isContestAvailable = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getContestList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ContestProvider>(context, listen: false);

    return isLoading
        ?  Scaffold(body: buildLoading())
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.site),
              backgroundColor: mainColor,
              centerTitle: true,
              elevation: 1,
            ),
            body: isContestAvailable
                ? Center(
                    child: Text(
                      "No Context Available",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: mainColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index){
                      final difference = DateTime.parse(
                              pro.individualContestList[index].startTime)
                          .difference(DateTime.now())
                          .inSeconds;
                      int endTimeForTimer =
                          DateTime.now().millisecondsSinceEpoch +
                              1000 * difference;
                      return buildContestWidget(
                        endTimeForTimer: endTimeForTimer,
                        index: index,
                        pro: pro,
                        site: widget.site,
                        context: context,
                      );
                    },
                    itemCount: pro.individualContestList.length,
                  ),
          );
  }
}
