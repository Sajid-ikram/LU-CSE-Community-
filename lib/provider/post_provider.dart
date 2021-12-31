
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';

class PostProvider with ChangeNotifier{
  Future addNewPost({
    required String userName,
    required String postText,
    required String imageUrl,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("posts").doc().set(
        {
          "userName": userName,
          "postText": postText,
          "imageUrl": imageUrl,
          "dateTime": dateTime,
          "ownerUid" : FirebaseAuth.instance.currentUser!.uid,
          "likes" : "0",
          "comments" : "0",
        },
      );

      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");

    }
  }
}