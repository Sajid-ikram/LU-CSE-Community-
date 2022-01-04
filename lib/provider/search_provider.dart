
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier{
  String searchText = "";
  String searchUserNameText = "";

  searchPost(String text){
    searchText = text;
    notifyListeners();
  }

  searchUser(String text){
    searchUserNameText = text;
    notifyListeners();
  }
}