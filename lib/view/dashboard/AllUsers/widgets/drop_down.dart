import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({Key? key, required this.currentRole, required this.uid})
      : super(key: key);
  String currentRole;
  String uid;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  List<String> listOfRole = [];

  @override
  Widget build(BuildContext context) {
    String role = Provider.of<ProfileProvider>(context, listen: false).role;

    if (role == "Admin") {
      if(widget.currentRole == "Teacher"){
        listOfRole = ['Teacher', 'TeacherP'];
      }else{
        listOfRole = ['Student', "Moderator"];
      }

    } else if (role == "Teacher") {
      listOfRole = ['Student', "Moderator"];
    }
    //listOfRole = ['Student', 'Moderator'];
    return Container(
      height: 55.h,
      width: 120.w,
      padding: const EdgeInsets.only(right: 20),
      child: Center(
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.currentRole,
          icon: const Icon(FontAwesomeIcons.caretDown),
          iconSize: 18,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: const SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              confirmChange(newValue,context,widget.uid);
            }
          },
          items: listOfRole.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(value),
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }


}

Future confirmChange(String massage,BuildContext context,String uid) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Are you sure'),
      content: Text("Do you want to change the role to $massage"),
      actions: <Widget>[
        TextButton(
          child: const Text("OK"),
          onPressed: () async {
            await Provider.of<ProfileProvider>(context, listen: false)
                .updateRole(uid, massage, context);
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
