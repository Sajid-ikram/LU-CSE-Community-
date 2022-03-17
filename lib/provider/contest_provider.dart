import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:lu_cse_community/Models/individual_contest_model.dart';
import 'package:lu_cse_community/view/Contest/SubPage/SubWidgets/error_dialoge.dart';

class ContestProvider with ChangeNotifier {
  List<IndividualModel> individualContestList = [];

  getAllContest(String text, BuildContext context) async {
    var siteUrl = 'https://kontests.net/api/v1/all';

    var url = Uri.parse(siteUrl);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      individualContestList.clear();

      if (text == "All future contest") {
        var jsonResponse = convert.jsonDecode(response.body);

        for (var con in jsonResponse) {
          bool isBeforeNow = false;
          String result = "";

          if (con["start_time"].contains(" UTC")) {
            result = con["start_time"]
                .substring(0, con["start_time"].indexOf(' UTC'));
          } else {
            result = con["start_time"];
          }
          isBeforeNow =
              DateTime.now().isBefore(DateTime.parse(result).toLocal());

          bool notCFGym = con["site"] == "CodeForces::Gym";

          if (isBeforeNow && !notCFGym) {
            individualContestList.add(IndividualModel.fromJson(con, true));
          }
        }
      } else if (text == "All contest within 24 hour") {
        var jsonResponse = convert.jsonDecode(response.body);
        for (var con in jsonResponse) {
          String result1 = "";

          if (con["start_time"].contains(" UTC")) {
            result1 = con["start_time"]
                .substring(0, con["start_time"].indexOf(' UTC'));
          } else {
            result1 = con["start_time"];
          }

          bool isBeforeNow =
              DateTime.now().isBefore(DateTime.parse(result1).toLocal());

          DateTime now = DateTime.now();
          DateTime oneDaysFromNow = now.add(const Duration(days: 1));

          bool isWithin24Hour =
              oneDaysFromNow.isBefore(DateTime.parse(result1).toLocal());

          bool notCFGym = con["site"] == "CodeForces::Gym" || con["site"] == "";

          if (isBeforeNow && !isWithin24Hour && !notCFGym) {
            individualContestList.add(IndividualModel.fromJson(con, true));
          }
        }
      } else if (text == "All contest in tomorrow") {
        var jsonResponse = convert.jsonDecode(response.body);

        for (var con in jsonResponse) {
          bool isBeforeNow = false;

          String result = "";

          if (con["start_time"].contains(" UTC")) {
            result = con["start_time"]
                .substring(0, con["start_time"].indexOf(' UTC'));
          } else {
            result = con["start_time"];
          }

          DateTime conDate = DateTime.parse(result).toLocal();
          isBeforeNow = DateTime.now().isBefore(conDate);

          DateTime now = DateTime.now();
          DateTime oneDaysFromNow = now.add(const Duration(days: 1));

          bool isTomorrow = false;
          if (oneDaysFromNow.year == conDate.year &&
              oneDaysFromNow.month == conDate.month &&
              oneDaysFromNow.day == conDate.day) {
            isTomorrow = true;
          }
          bool notCFGym = con["site"] == "CodeForces::Gym";

          if (isBeforeNow && isTomorrow && !notCFGym) {
            individualContestList.add(IndividualModel.fromJson(con, true));
          }
        }
      }
      individualContestList
          .sort((a, b) => (a.startTime).compareTo(b.startTime));
    } else {
      return onError(context, "Having problem connecting to the server")
          .then((value) => Navigator.of(context).pop());
    }
  }

  getIndividualContest(String text, BuildContext context) async {
    String siteUrl = "";
    individualContestList.clear();

    if (text == "CodeForces") {
      siteUrl = 'https://www.kontests.net/api/v1/codeforces';
    } else if (text == "CodeChef") {
      siteUrl = 'https://www.kontests.net/api/v1/code_chef';
    } else if (text == "TopCoder") {
      siteUrl = 'https://www.kontests.net/api/v1/top_coder';
    } else if (text == "AtCoder") {
      siteUrl = 'https://www.kontests.net/api/v1/at_coder';
    } else if (text == "CSAcademy") {
      siteUrl = 'https://www.kontests.net/api/v1/cs_academy';
    } else if (text == "HackerRank") {
      siteUrl = 'https://www.kontests.net/api/v1/hacker_rank';
    } else if (text == "HackerEarth") {
      siteUrl = 'https://www.kontests.net/api/v1/hacker_earth';
    } else if (text == "LeetCode") {
      siteUrl = 'https://www.kontests.net/api/v1/leet_code';
    }

    try {
      var url = Uri.parse(siteUrl);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        for (var con in jsonResponse) {
          String result = "";

          if (con["start_time"].contains(" UTC")) {
            result = con["start_time"]
                .substring(0, con["start_time"].indexOf(' UTC'));
          } else {
            result = con["start_time"];
          }

          bool isBeforeNow =
              DateTime.now().isBefore(DateTime.parse(result).toLocal());

          if (isBeforeNow) {
            individualContestList.add(IndividualModel.fromJson(con, false));
          }
        }

        individualContestList
            .sort((a, b) => (a.startTime).compareTo(b.startTime));
      } else {
        return onError(context, "Having problem connecting to the server")
            .then((value) => Navigator.of(context).pop());
      }
    } catch (e) {
      return onError(context, "Having problem connecting to the server")
          .then((value) => Navigator.of(context).pop());
    }
  }
}
