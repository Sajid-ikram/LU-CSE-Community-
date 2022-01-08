import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/provider/all_users_provider.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/provider/search_provider.dart';
import 'package:lu_cse_community/view/dashboard/AllUsers/widgets/drop_down.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AllUserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: pro.getStreamQuerySnapshot(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data;
        if (data != null) {}
        return Consumer<SearchProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                String name = data?.docs[index]["name"];
                if (name.toLowerCase().contains(provider.searchUserNameText)) {
                  return Column(
                    children: [
                      Container(
                        height: 30,
                        width: 350,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            data?.docs[index]["url"] != ""
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 21,
                                    backgroundImage: NetworkImage(
                                      data?.docs[index]["url"],
                                    ),
                                  )
                                : const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 21,
                                    backgroundImage:
                                        AssetImage("assets/profile.jpg"),
                                  ),
                            SizedBox(width: 12.w),
                            Text(
                              data?.docs[index]["name"],
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            Consumer<ProfileProvider>(
                              builder: (context, provider, child) {
                                if (provider.role == "Student" ||
                                    provider.role == "Moderator") {
                                  return buildNonChangeableRole(data!, index);
                                } else if (provider.role == "Admin") {
                                  return CustomDropDown(
                                    currentRole: data?.docs[index]["role"],
                                    uid: data?.docs[index].id ?? "",
                                  );
                                } else if (provider.role == "Teacher") {
                                  if (pro.selectedFilter == "Student" ||
                                      pro.selectedFilter == "Moderator") {
                                    return CustomDropDown(
                                      currentRole: data?.docs[index]["role"],
                                      uid: data?.docs[index].id ?? "",
                                    );
                                  } else {
                                    return buildNonChangeableRole(data!, index);
                                  }
                                }
                                return buildNonChangeableRole(data!, index);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1,)
                    ],
                  );
                }
                return const SizedBox();
              },
              itemCount: data?.size,
            );
          },
        );
      },
    );
  }

  SizedBox buildNonChangeableRole(QuerySnapshot data, int index) {
    return SizedBox(
      width: 130.w,
      child: Center(
        child: Text(
          data.docs[index]["role"],
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
