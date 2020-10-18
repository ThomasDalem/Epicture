import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'JsonPostedImageParser.dart';
import 'UserInfo.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<PostedImage> _images = List<PostedImage>();

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get("https://api.imgur.com/3/account/me/images", headers: {
      "Authorization": "Bearer ${userInfos.accessToken}"
    }).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _images = parsePostedImageData(response.body).data;
          print(_images.length);
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
          return PostedImageWidget(data: _images[index]);
        },
      ),
    );
  }
}

class PostedImageWidget extends StatelessWidget {
  final PostedImage data;

  PostedImageWidget({this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null || data.isAnimated) {
      return Container();
    }
    return Card(
        color: const Color(0xFF2D1F5D),
        margin: EdgeInsets.all(10),
        child: InkWell(
            splashColor: Colors.white.withAlpha(30),
            child: Column(children: <Widget>[
              Image.network(data.url, fit: BoxFit.contain),
            ])));
  }
}
