import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'HomePage.dart';
import 'UserInfo.dart';
import 'CustomProfilAppBarButton.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<String> _imagesURL = List<String>();

  @override
  void initState() {
  }

  ListTile imagesBuilder(BuildContext context, int index) {
    return ListTile(
      title: Image.network(_imagesURL[index]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        leading: CustomProfilAppBarButton(redirect: false,),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView.builder(
        itemCount: _imagesURL.length,
        itemBuilder: imagesBuilder,
      ),
    );
  }
}