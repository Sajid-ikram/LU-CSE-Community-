import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

import '../view/public_widget/build_loading.dart';

class ProfileProvider extends ChangeNotifier {
  String profileUrl = '';
  String profileName = '';
  String role = '';
  String email = '';
  String section = '';
  String batch = '';
  String bio = '';
  String currentUserUid = '';
  List<String> favouritePostIds = [];

  getUserInfo(String id) async {
    DocumentSnapshot userInfo =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    profileUrl = userInfo["url"];
    profileName = userInfo["name"];
    role = userInfo["role"];
    email = userInfo["email"];
    section = userInfo["section"];
    batch = userInfo["batch"];
    bio = userInfo["bio"];
    currentUserUid = id;

    final snapShot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUid)
        .collection("favouritePosts")
        .get();

    favouritePostIds.clear();
    if (snapShot.docs.isNotEmpty) {
      for (int i = 0; i < snapShot.docs.length; i++) {
        favouritePostIds.add(snapShot.docs[i].id);
      }
    }
    print(favouritePostIds.length);
    print("favouritePostIds.length ++++++++++++++++++++++++++++++");
    notifyListeners();
  }

  Future<DocumentSnapshot> getProfileInfoByUID(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future updateProfileInfo({
    required String name,
    required String batch,
    required String section,
    required String bio,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(currentUserUid).update(
        {
          "name": name,
          "batch": batch,
          "section": section,
          "bio": bio,
        },
      );
      profileName = name;
      this.section = section;
      this.batch = batch;
      this.bio = bio;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updateProfileUrl(File _imageFile, BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      buildLoadingIndicator(context);
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child("profileImage")
          .child(auth.currentUser!.uid);
      final result = await ref.putFile(_imageFile);
      final url = await result.ref.getDownloadURL();
      FirebaseFirestore.instance.collection("users").doc(currentUserUid).update(
        {"url": url},
      );
      profileUrl = url;
      Navigator.of(context, rootNavigator: true).pop();
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

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
