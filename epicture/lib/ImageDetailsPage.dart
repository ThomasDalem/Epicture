import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'JsonImageParser.dart';
import 'UserInfo.dart';

class ImageDetailsPage extends StatefulWidget {
  final ImageData imageData;

  ImageDetailsPage({@required this.imageData});

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  void favoriteImage(MyImage imageData) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.post('https://api.imgur.com/3/image/${imageData.id}/favorite',
        headers: {"Authorization": "Bearer " + userInfos.accessToken}).then((response) {
      if (response.statusCode == 200) {
        this.setState(() {
          imageData.isFavorite = !imageData.isFavorite;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          title: Text(widget.imageData.title),
          actions: [
            CustomProfilAppBarButton(
              redirect: true,
            )
          ],
        ),
        body: Column(children: [
          Text(widget.imageData.accountUsername, style: TextStyle(color: Colors.white)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(text: widget.imageData.upVotes.toString(), style: TextStyle(color: Colors.green)),
                WidgetSpan(
                    child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 14,
                  color: Colors.green,
                ))
              ]),
            ),
            Text("${widget.imageData.imagesInfos.length} photos"),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: widget.imageData.downVotes.toString(), style: TextStyle(color: Colors.red)),
                WidgetSpan(
                    child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: Colors.red,
                ))
              ]),
            )
          ]),
          Expanded(
              child: PageView.builder(
                  itemCount: widget.imageData.imagesInfos.length,
                  itemBuilder: (context, index) => Stack(alignment: Alignment.center, children: [
                        Image.network(widget.imageData.imagesInfos[index].url, fit: BoxFit.contain),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: widget.imageData.imagesInfos[index].isFavorite == true
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: Colors.red,
                            onPressed: () => favoriteImage(widget.imageData.imagesInfos[index]),
                          ),
                        )
                      ])))
        ]));
  }
}
