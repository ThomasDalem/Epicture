import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'UserInfo.dart';
import 'CustomProfilAppBarButton.dart';
import 'JsonImageParser.dart';
import 'ImageWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ImageData> _images = List<ImageData>();

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    http.get("https://api.imgur.com/3/account/" + userInfos.accountUsername,
        headers: {
          "Authorization": "Bearer " + userInfos.accessToken,
        }).then((response) {
      if (response.statusCode == 200) {
        var values = json.decode(response.body);
        var data = values['data'];
        Provider.of<UserInfo>(context, listen: false).getAvatar(data['avatar']);
      }
    });
    http.get("https://api.imgur.com/3/gallery/hot/viral/", headers: {
      "Authorization": "Bearer ${userInfos.accessToken}"
    }).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _images = parseData(response.body).data;
          print(_images.length);
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: CustomProfilAppBarButton(
          redirect: true,
        ),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageWidget(data: _images[index]);
        },
      ),
    );
  }
}
