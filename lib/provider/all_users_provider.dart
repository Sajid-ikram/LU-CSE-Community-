import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AllUserProvider extends ChangeNotifier {
  String selectedFilter = "Student";
  bool showPendingPage = false;


  getStreamQuerySnapshot() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: selectedFilter)
        .snapshots();
  }

  changePendingPage(bool value){
    showPendingPage = value;
    notifyListeners();
  }

  changeFilter(String text){
    selectedFilter = text;
    notifyListeners();
  }


}
