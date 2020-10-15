import 'package:flutter/material.dart';

import 'StartPage.dart';
import 'UserInfo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserInfo.accessToken = null;
    UserInfo.expiresIn = null;
    UserInfo.refreshToken = null;
    UserInfo.accountUsername = null;
    UserInfo.accountID = null;
    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        fontFamily: 'Arial',
        backgroundColor: Color(0xFF3C3C3C),
        primaryColorLight: Color(0xFF8c32fa),
        primaryColorDark: Color(0xFF5a1ea0),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {'/home': (_) => StartPage()},
    );
  }
}
