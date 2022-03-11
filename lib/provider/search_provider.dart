
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier{
  String searchText = "";
  String searchLUCCAndACMPost = "";
  String searchUserNameText = "";

  searchPost(String text){
    searchText = text;
    notifyListeners();
  }

  changeSearchLUCCAndACMPost(String text){
    searchLUCCAndACMPost = text;
    notifyListeners();
  }

  searchUser(String text){
    searchUserNameText = text;
    notifyListeners();
  }
}