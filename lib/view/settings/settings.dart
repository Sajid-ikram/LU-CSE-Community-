import 'package:flutter/material.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings"),
            IconButton(
                onPressed: () {
                  Provider.of<Authentication>(context,listen: false).signOut();
                },
                icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}
