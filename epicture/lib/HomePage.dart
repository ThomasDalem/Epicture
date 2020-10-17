import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'UserInfo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String avatar;
  List<Image> listImage = [
    Image.network('https://picsum.photos/250?image=9'),
    Image.network('https://picsum.photos/250?image=1'),
    Image.network('https://picsum.photos/250?image=2'),
    Image.network('https://picsum.photos/250?image=8'),
  ];

  @override
  void initState() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    avatar = "";
    print(userInfos.accountUsername);
    http.get("https://api.imgur.com/3/account/" + userInfos.accountUsername, headers: {
      "Authorization": "Bearer " + userInfos.accessToken,
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var values = json.decode(response.body);
        var data = values['data'];
        setState(() {
          avatar = data['avatar'];
        });
        Provider.of<UserInfo>(context, listen: false).getAvatar(data['avatar']);
      }
    });
  }

  Widget build(BuildContext context) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: Image.network(userInfos.avatarUrl),
    );
  }
}
