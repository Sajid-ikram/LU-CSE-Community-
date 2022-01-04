import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AllUserProvider extends ChangeNotifier {
  String selectedFilter = "Student";

  getStreamQuerySnapshot() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: selectedFilter)
        .snapshots();
  }

  changeFilter(String text){
    selectedFilter = text;
    notifyListeners();
  }


}
