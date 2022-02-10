import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/provider/sign_up_provider.dart';
import 'package:lu_cse_community/view/settings/widgets/build_top.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../public_widget/build_loading.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController changeNameController;
  late TextEditingController changeBatchController;
  late TextEditingController changeSectionController;
  late TextEditingController changeBioController;
  String role = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    changeNameController = TextEditingController(text: pro.profileName);
    changeBatchController = TextEditingController(text: pro.batch);
    changeSectionController = TextEditingController(text: pro.section);
    changeBioController = TextEditingController(text: pro.bio);
    role = pro.role;
    super.initState();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileInfo(
          name: changeNameController.text,
          bio: changeBioController.text,
          batch: changeBatchController.text,
          section: changeSectionController.text,
          context: context,
        )
            .then(
          (value) async {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Profile updated successfully",
                  style: TextStyle(color: mainColor),
                ),
                backgroundColor: Colors.greenAccent,

              ),
            );
          },
        );
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 837.h,
          padding: EdgeInsets.all(32.sp),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              buildTop("Edit Profile", context),
              SizedBox(height: 35.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildContainer(
                        "Change name", changeNameController, context),
                    if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Batch", changeBatchController, context),
                    if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Section", changeSectionController, context),
                    _buildContainer("Change Bio", changeBioController, context),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: buildButton("Save Now", 350, 16, 54),
              ),
              SizedBox(height: 10.h,)
            ],
          ),
        ),
      ),
    );
  }
}

Container _buildContainer(
    String text, TextEditingController controller, BuildContext context) {
  var pro = Provider.of<SignUpProvider>(context, listen: false);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    width: 400.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
              color: const Color(0xff6a6a6a),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10.h),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.justify,
          controller: controller,

          validator: (value) {
            if (text == "Change name") {
              if(value != null && value.length > 50){
                return "Name should be less then 50 character";
              }
              else if (value == null || value.isEmpty) {
                return "Field can not be empty!";
              }
            }
            else if (text == "Change Batch") {
              if(value != null && value.length > 5){
                return "Batch should be less then 5 character";
              }
              else if (value == null || value.isEmpty) {
                return "Field can not be empty!";
              }
            }
            else if (text == "Change Section") {
              if(value != null && value.length > 1){
                return "Section should be 1 character long";
              }
              else if (value == null || value.isEmpty) {
                return "Field can not be empty!";
              }
            }
            else if(text == "Change Bio"){
              return null;
            }
            else if (value == null || value.isEmpty) {
              return "Field can not be empty!";
            }

          },
          minLines: text == "Change Bio" ? 5 : 1,
          maxLines: 6,
          maxLength: text ==  "Change Bio" ? 100 : null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(false, pro, text),
        )
      ],
    ),
  );
}
