import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'UserInfo.dart';
import 'CustomProfilAppBarButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imagesURL = List<String>();

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    http.get("https://api.imgur.com/3/account/" + userInfos.accountUsername,
        headers: {
          "Authorization": "Bearer " + userInfos.accessToken,
        }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var values = json.decode(response.body);
        var data = values['data'];
        Provider.of<UserInfo>(context, listen: false).getAvatar(data['avatar']);
      }
    });
    http.get("https://api.imgur.com/3/gallery/hot/viral/", headers: {
      "Authorization": "Bearer ${userInfos.accessToken}"
    }).then((response) {
      if (response.statusCode == 200) {
        final values = json.decode(response.body);
        final data = values['data'];
        setState(() {
          for (var val in data) {
            final images = val['images'];
            if (images != null && images[0]['animated'] == false) {
              print(images[0]);
              _imagesURL.add(images[0]['link']);
            }
          }
        });
      }
    });
  }

  ListTile imagesBuilder(BuildContext context, int index) {
    return ListTile(
      title: Image.network(_imagesURL[index]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: CustomProfilAppBarButton(redirect: true,),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView.builder(
        itemCount: _imagesURL.length,
        itemBuilder: imagesBuilder,
      ),
    );
  }
}