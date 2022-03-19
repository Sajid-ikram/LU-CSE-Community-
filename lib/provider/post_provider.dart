import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';

class PostProvider with ChangeNotifier {
  bool isLoading = false;
  bool isLoveLoading = false;
  bool loadingComment = false;
  String commentText = '';
  bool isNewPostAdded = false;

  changeCommentText(String text) {
    commentText = text;
    notifyListeners();
  }

  Future addNewComment({
    required String postId,
    required String uid,
    required String comment,
    required String dateTime,
    required BuildContext context,
  }) async {
    try {
      loadingComment = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection("thoseWhoComment")
          .doc()
          .set({
        "commentText": commentText,
        "dateTime": dateTime,
        "ownerUid": uid,
      });

      await FirebaseFirestore.instance.collection("posts").doc(postId).update(
        {"comments": (int.parse(comment) + 1).toString()},
      );

      loadingComment = false;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future addNewPost({
    required String userName,
    required String profileUrl,
    required String postText,
    required String imageUrl,
    required String dateTime,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("posts").doc().set(
        {
          "userName": userName,
          "postText": postText,
          "imageUrl": imageUrl,
          "dateTime": dateTime,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
          "likes": "0",
          "comments": "0",
        },
      );
      isNewPostAdded = !isNewPostAdded;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updatePost({
    required String postText,
    required String id,
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("posts").doc(id).update(
        {
          "postText": postText,
          "imageUrl": imageUrl,
        },
      );
      isNewPostAdded = !isNewPostAdded;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<bool> isAlreadyLiked({
    required String postId,
    required String uid,
  }) async {
    DocumentSnapshot thoseWhoLike = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("thoseWhoLike")
        .doc(uid)
        .get();

    if (thoseWhoLike.exists) {
      return true;
    } else {
      return false;
    }
  }

  likeAPost({
    required String postId,
    required String uid,
    required String likes,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      bool isExist = await isAlreadyLiked(uid: uid, postId: postId);

      if (isExist) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection("thoseWhoLike")
            .doc(uid)
            .delete();

        await FirebaseFirestore.instance.collection("posts").doc(postId).update(
          {"likes": (int.parse(likes) - 1).toString()},
        );
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection("thoseWhoLike")
            .doc(uid)
            .set({uid: "1"});

        await FirebaseFirestore.instance.collection("posts").doc(postId).update(
          {"likes": (int.parse(likes) + 1).toString()},
        );
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<String> addToFavourite({
    required String postId,
    required String uid,
    required bool isExist,
    required BuildContext context,
  }) async {
    try {
      isLoveLoading = true;
      notifyListeners();

      if (isExist) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection("favouritePosts")
            .doc(postId)
            .delete();

        isLoveLoading = false;
        notifyListeners();
        return "Deleted";
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection("favouritePosts")
            .doc(postId)
            .set({uid: "1"});
      }
      isLoveLoading = false;
      notifyListeners();
      return "Added";
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  Future deletePost(String id) async {
    await FirebaseFirestore.instance.collection("posts").doc(id).delete();
    notifyListeners();
  }
}
