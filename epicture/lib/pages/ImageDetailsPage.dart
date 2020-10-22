import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../widgets/CustomProfilAppBarButton.dart';
import '../parsers/JsonImageParser.dart';
import '../providers/UserInfo.dart';
import '../widgets/VideoPlayerWidget.dart';

Widget chooseMediaPlayer(MyImage data) {
  if (data.type == 'video/mp4') {
    return VideoPlayerWidget(videoLink: data.url);
  } else if (data.type.contains("video/")) {
    return Container();
  }
  return Image.network(
    data.url,
    fit: BoxFit.contain,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    },
  );
}

class ImageDetailsPage extends StatefulWidget {
  final ImageData imageData;

  ImageDetailsPage({@required this.imageData});

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  ImageList _favoriteImages;
  ImageList _images = new ImageList();

  void favoriteImage(MyImage imageData) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.post('https://api.imgur.com/3/image/${imageData.id}/favorite',
        headers: {
          'Authorization': 'Bearer ${userInfos.accessToken}'
        }).then((response) {
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['data'] == 'favorited') {
          this.setState(() {
            imageData.isFavorite = true;
          });
        } else {
          this.setState(() {
            imageData.isFavorite = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _images.images = [];
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    List<String> favoritesID;

    if (widget.imageData.imagesNbr != widget.imageData.imagesInfos.length) {
      http.get('https://api.imgur.com/3/gallery/album/${widget.imageData.id}',
          headers: {
            'Authorization': 'Bearer ${userInfos.accessToken}'
          }).then((response) {
        if (response.statusCode == 200) {
          this.setState(() {
            _images.images =
                ImageData.fromJson(jsonDecode(response.body)['data'])
                    .imagesInfos;
          });
        }
      });
    } else {
      _images.images = widget.imageData.imagesInfos;
    }
    http.get(
        'https://api.imgur.com/3/account/${userInfos.accountUsername}/favorites/',
        headers: {
          'Authorization': 'Bearer ${userInfos.accessToken}'
        }).then((response) {
      if (response.statusCode == 200) {
        this.setState(
          () {
            _favoriteImages = new ImageList.fromJson(jsonDecode(response.body));
            favoritesID =
                _favoriteImages.images.map((elem) => elem.id).toList();
            for (var image in widget.imageData.imagesInfos) {
              if (favoritesID.contains(image.id)) {
                image.isFavorite = true;
              }
            }
          },
        );
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text(widget.imageData.title),
        leading: CustomProfilAppBarButton(
          redirect: true,
        ),
      ),
      body: Column(children: [
        Text(widget.imageData.accountUsername,
            style: TextStyle(color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: widget.imageData.upVotes.toString(),
                      style: TextStyle(color: Colors.green)),
                  WidgetSpan(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Text("${widget.imageData.imagesNbr} photos"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: widget.imageData.downVotes.toString(),
                      style: TextStyle(color: Colors.red)),
                  WidgetSpan(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: PageView.builder(
            itemCount: _images.images.length,
            itemBuilder: (context, index) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  IconButton(
                    icon: _images.images[index].isFavorite == true
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () => favoriteImage(_images.images[index]),
                  ),
                  chooseMediaPlayer(_images.images[index])
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
