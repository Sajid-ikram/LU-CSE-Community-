import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../view/public_widget/build_loading.dart';

class PDFAndNotificationProvider extends ChangeNotifier {
  Future uploadPDF(File file, BuildContext context, String text) async {
    try {
      buildLoadingIndicator(context);
      final ref =
          storage.FirebaseStorage.instance.ref().child("PDF").child(text);

      final result = await ref.putFile(file);
      final url = await result.ref.getDownloadURL();
      String name = '';
      if (text == "Bus Schedule") {
        name = "busUrl";
      } else {
        name = "routineUrl";
      }
      FirebaseFirestore.instance.collection("PDF").doc(text).set(
        {name: url},
      );
      Navigator.of(context, rootNavigator: true).pop();
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future sendNotification(List<String> tokenIdList, String contents,
      String heading, String url) async {
    try{
      return await post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Basic \u003cZTg0NDI1YzMtNGU3Mi00MDhmLTkwMTYtMmRhYjZhYTJjNDRl\u003e'
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": kAppId,
          //kAppId is the App Id that one get from the OneSignal When the application is registered.

          "included_segments": ["Subscribed Users"],

          "large_icon": url,

          "headings": {"en": heading},

          "contents": {"en": contents},
        }),
      );
    }catch(e){
      print("---------------------------------------------------------");
      print(e);
    }

  }
}
