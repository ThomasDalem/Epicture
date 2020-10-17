import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'UserInfo.dart';
import 'AccountPage.dart';

class CustomProfilAppBarButton extends StatelessWidget {
  bool redirect;

  CustomProfilAppBarButton({this.redirect});

  @override
  Widget build(BuildContext context) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    return Container(
      child: MaterialButton(
        padding: EdgeInsets.all(1),
        shape: CircleBorder(),
        onPressed: () {
          if (redirect == true)
            Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AccountPage()));
        },
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(userInfos.avatarUrl),
        ),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(4),
    );
  }
}