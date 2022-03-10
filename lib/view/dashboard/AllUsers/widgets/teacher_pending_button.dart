import 'package:flutter/material.dart';
import 'package:lu_cse_community/provider/all_users_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/widgets/build_row_button.dart';
import 'package:provider/provider.dart';

class TeacherPendingButton extends StatefulWidget {
  const TeacherPendingButton({Key? key}) : super(key: key);

  @override
  _TeacherPendingButtonState createState() => _TeacherPendingButtonState();
}

class _TeacherPendingButtonState extends State<TeacherPendingButton> {
  @override
  Widget build(BuildContext context) {
    var profilePro = Provider.of<ProfileProvider>(context, listen: false);
    return Consumer<AllUserProvider>(
      builder: (context, provider, child) {
        return (provider.selectedFilter == "Teacher" ||
                provider.selectedFilter == "TeacherP") &&
                    (profilePro.role == "Admin")
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.changeFilter("Teacher");
                        provider.changePendingPage(false);
                      },
                      child:
                          buildRowButton("Approved", !provider.showPendingPage),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.changeFilter("TeacherP");
                        provider.changePendingPage(true);
                      },
                      child:
                          buildRowButton("Pending", provider.showPendingPage),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
