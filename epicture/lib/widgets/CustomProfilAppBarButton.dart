import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/UserInfo.dart';
import '../pages/AccountPage.dart';

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
          if (redirect == true) Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
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
