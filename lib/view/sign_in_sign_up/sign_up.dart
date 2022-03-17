import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:lu_cse_community/provider/sign_up_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/build_row_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_button.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/custom_text_field.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/promise.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/top.dart';
import 'package:provider/provider.dart';

import '../public_widget/build_loading.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  bool isTeacher = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    batchController.clear();
    sectionController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(
          name: nameController.text,
          email: emailController.text,
          password: confirmPasswordController.text,
          batch: batchController.text,
          section: sectionController.text,
          context: context,
        )
            .then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pro = Provider.of<SignUpProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              SizedBox(
                width: 414.w,
                height: 837.h - statusBarHeight,
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    Text(
                      "Welcome!",
                      style: GoogleFonts.inter(
                        fontSize: 45.sp,
                        color: mainColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    buildPromise(15),
                    SizedBox(height: 28.h),
                    Padding(
                      padding: EdgeInsets.only(left: 37.w, bottom: 8.h),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTeacher = false;
                                  });
                                },
                                child: buildRowButton("Student", !isTeacher),
                              ),
                              SizedBox(width: 15.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTeacher = true;
                                  });
                                },
                                child: buildRowButton("Teacher", isTeacher),
                              ),
                            ],
                          )),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          customTextField(nameController, "Enter your name",
                              false, context),
                          customTextField(
                              emailController, "Email Address", false, context),
                          customTextField(pro.passwordController, "Password",
                              false, context),
                          customTextField(confirmPasswordController,
                              "Confirm Password", false, context),
                          if (!isTeacher)
                            customTextField(
                                batchController, "Batch", false, context),
                          if (!isTeacher)
                            customTextField(
                                sectionController, "Section", false, context),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 22.w),
                        Consumer<SignUpProvider>(
                          builder: (context, provider, child) {
                            return Checkbox(
                              activeColor: Colors.greenAccent,
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: provider.isChecked,
                              onChanged: (bool? value) {
                                provider.changeCheckBox();
                              },
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed("TermsAndCondition");
                          },
                          child: Text(
                            "I agree to the Terms and Conditions",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: mainColor.withOpacity(0.8),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (pro.isChecked) {
                          validate();
                        } else {
                          snackBar(context, "You have to agree to continue");
                        }
                      },
                      child: buildButton("Sign Up", 350, 20, 56),
                    ),
                    SizedBox(height: 15.h),
                    switchPageButton(
                        "Already have an account? - ", "Sign In", context),
                  ],
                ),
              ),
              top(context, "OnBoarding"),
            ],
          ),
        ),
      ),
    );
  }
}

Color getColor(Set<MaterialState> states) {
  return mainColor;
}
