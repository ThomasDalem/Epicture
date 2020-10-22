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
      if (response.statusCode == 200) {
        setState(() {
          _images = parsePostedAndFavoriteImageData(response.body).data;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Theme.of(context).primaryColorLight, Color(0xFF3D156B)]))),
        title: Text('Favorites'),
          actions: [CustomProfilAppBarButton(redirect: false)],
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return PostedAndFavoriteImageWidget(data: _images[index]);
        },
      ),
    );
  }
}