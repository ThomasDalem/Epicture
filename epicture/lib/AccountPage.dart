import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'JsonPostedAndFavoriteImageParser.dart';
import 'UserInfo.dart';
import 'FavoritePage.dart';
import 'PostedAndFavoriteImageWidget.dart';
import 'UploadPostPage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<PostedAndFavoriteImage> _images = List<PostedAndFavoriteImage>();

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get("https://api.imgur.com/3/account/me/images",
        headers: {"Authorization": "Bearer ${userInfos.accessToken}"}).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _images = parsePostedAndFavoriteImageData(response.body).data;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(userInfos.accountUsername),
        actions: [CustomProfilAppBarButton(redirect: false)],
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return PostedAndFavoriteImageWidget(data: _images[index]);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            Expanded(
                child: IconButton(
              color: Color(0xFFFFFFFF),
              icon: Icon(Icons.file_upload),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPostPage()));
              },
            )),
            Expanded(
                child: IconButton(
              color: Color(0xFFFFFFFF),
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()));
              },
            )),
          ],
        ),
      ),
    );
  }
}
