import 'package:flutter/material.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chat"),
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
