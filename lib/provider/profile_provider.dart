import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';

class ProfileProvider extends ChangeNotifier {
  String profileUrl = '';
  String profileName = '';
  String role = '';

  getUserInfo(String id) async {
    DocumentSnapshot userInfo =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    profileUrl = userInfo["url"];
    profileName = userInfo["name"];
    role = userInfo["role"];
    notifyListeners();
  }

  Future<DocumentSnapshot> getProfileInfoByUID(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

/*  Future updateProfileUrl(String url, String uid, BuildContext context) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(uid).update(
        {"url": url},
      );
      profileUrl = url;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }*/

  Future updateRole(String uid, String role, BuildContext context) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(uid).update(
        {"role": role},
      );

      if (uid == FirebaseAuth.instance.currentUser?.uid) {
        await getUserInfo(FirebaseAuth.instance.currentUser?.uid ?? "");
        notifyListeners();
      }
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }
}
