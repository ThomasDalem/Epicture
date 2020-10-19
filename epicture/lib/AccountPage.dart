import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'JsonPostedAndFavoriteImageParser.dart';
import 'UserInfo.dart';
import 'FavoritePage.dart';
import 'PostedAndFavoriteImageWidget.dart';

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

    http.get("https://api.imgur.com/3/account/me/images", headers: {
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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF5a1ea0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.upload_file),
                onPressed: () {},
              )
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()));
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}