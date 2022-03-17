import 'package:flutter/material.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:lu_cse_community/view/settings/widgets/favourite_post_list.dart';
import 'package:provider/provider.dart';
import '../public_widget/custom_app_bar.dart';

class FavouritePost extends StatelessWidget {
  const FavouritePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: customAppBar("Favourite", context),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return FavouritePostList(id: pro.favouritePostIds[index]);
        },
        itemCount: pro.favouritePostIds.length,
      ),
    );
  }
}
