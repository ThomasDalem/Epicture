import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'UserInfo.dart';

//String getAccessToken(String url) {}

String accessToken;
String refreshToken;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class MyImage {
  final String link;

  MyImage({this.link});

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      link: json['link'] as String,
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<Image> listImage = [
    Image.network('https://picsum.photos/250?image=9'),
    Image.network('https://picsum.photos/250?image=1'),
    Image.network('https://picsum.photos/250?image=2'),
    Image.network('https://picsum.photos/250?image=8'),
  ];

  @override
  void initState() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    http.get("https://api.imgur.com/3/gallery/hot/viral/0.json", headers: {
      "access_token": userInfos.accessToken,
      "refresh_token": userInfos.refreshToken,
      "token_type": "Bearer",
      "account_username": userInfos.accountUsername,
    }).then((response) {
      //print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        //var data = json.decode(response.body);
        //var rest = data["link"] as String;
        //var myImage = MyImage.fromJson(jsonDecode(response.body));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView(
        children: listImage,
      ),
    );
  }
}
