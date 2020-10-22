import 'package:epicture/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/UserInfo.dart';
import './pages/LoginPage.dart';

void main() => runApp(ChangeNotifierProvider<UserInfo>(
    create: (context) => UserInfo(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        fontFamily: 'Arial',
        backgroundColor: Color(0xFFFFFFFF),
        primaryColorLight: Color(0xFF8c32fa),
        primaryColorDark: Color(0xFF3C3C3C),
        primaryColor: Color(0xFF5a1ea0),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {'/login': (_) => StartPage()},
    );
  }
}
