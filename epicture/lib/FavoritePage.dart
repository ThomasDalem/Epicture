import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'UserInfo.dart';
import 'JsonPostedAndFavoriteImageParser.dart';
import 'PostedAndFavoriteImageWidget.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<PostedAndFavoriteImage> _images = List<PostedAndFavoriteImage>();

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get("https://api.imgur.com/3/account/" + userInfos.accountUsername + "/favorites/", headers: {
      "Authorization": "Bearer ${userInfos.accessToken}"
    }).then((response) {
      print(userInfos.accessToken);
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          _images = parsePostedAndFavoriteImageData(response.body).data;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        leading: CustomProfilAppBarButton(redirect: false,),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return PostedAndFavoriteImageWidget(data: _images[index]);
        },
      ),
    );
  }
}