import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/pdf_and_notification_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BusSchedule extends StatefulWidget {
  BusSchedule({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  _BusScheduleState createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule> {
  pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      var pro = Provider.of<PDFAndNotificationProvider>(context, listen: false);
      pro.uploadPDF(file, context, widget.name).then((value) async{
        await pro.sendNotification(
          ["fab732a6-8371-11ec-9974-d6a81ba95cb1"],
          widget.name,
          "${widget.name} Has Changed",
          "https://firebasestorage.googleapis.com/v0/b/lu-cse-community.appspot.com/o/notification%2Flu.png?alt=media&token=8ba2b183-49af-4673-a519-020fa1f3ca74",
        );
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.name,
          style: GoogleFonts.inter(
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
            color: mainColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        actions: [
          if(pro.role != "Student" && pro.role != "Moderator" && pro.role != "TeacherP")
          IconButton(
            onPressed: () {
              pickFile();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 24.sp,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("PDF").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data;
          var a = data?.docs.length;

          if (widget.name == "Bus Schedule") {
            for (int i = 0; i < a!; i++) {
              if (data?.docs[i].id == "Bus Schedule") {
                return SfPdfViewer.network(data?.docs[i]["busUrl"]);
              }
            }
            return pdfUnavailable();
          }
          for (int i = 0; i < a!; i++) {
            if (data?.docs[i].id == "Routine") {
              return SfPdfViewer.network(data?.docs[i]["routineUrl"]);
            }
          }
          return pdfUnavailable();
        },
      ),
    );
  }

  Center pdfUnavailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name == "Bus Schedule"
                ? "No Schedule added yet!"
                : "No routine yet! Add one",
            style: GoogleFonts.inter(
              fontSize: 19.sp,
              fontWeight: FontWeight.w500,
              color: mainColor,
            ),
          ),
          InkWell(
            onTap: () {
              pickFile();
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
