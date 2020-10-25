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

class _ImageDetailsPageState extends State<ImageDetailsPage>
    with TickerProviderStateMixin {
  ImageList _favoriteImages;
  ImageList _images = new ImageList();
  AnimationController _animControllerUp;
  AnimationController _animControllerDown;
  Animation<double> _animUp;
  Animation<double> _animDown;

  void voteUp() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    if (widget.imageData.vote == null) {
      http.post(
          'https://api.imgur.com/3/gallery/${widget.imageData.id}/vote/up',
          headers: {
            'Authorization': 'Bearer ${userInfos.accessToken}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            widget.imageData.vote = "up";
            _animControllerUp.forward();
          });
        }
      });
    } else if (widget.imageData.vote == "up") {
      http.post(
          'https://api.imgur.com/3/gallery/${widget.imageData.id}/vote/veto',
          headers: {
            'Authorization': 'Bearer ${userInfos.accessToken}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _animControllerUp.reverse();
            widget.imageData.vote = null;
          });
        }
      });
    }
  }

  void voteDown() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    if (widget.imageData.vote == null) {
      http.post(
          'https://api.imgur.com/3/gallery/${widget.imageData.id}/vote/down',
          headers: {
            'Authorization': 'Bearer ${userInfos.accessToken}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            widget.imageData.vote = "down";
            _animControllerDown.forward();
          });
        }
      });
    } else if (widget.imageData.vote == "down") {
      http.post(
          'https://api.imgur.com/3/gallery/${widget.imageData.id}/vote/veto',
          headers: {
            'Authorization': 'Bearer ${userInfos.accessToken}'
          }).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _animControllerDown.reverse();
            widget.imageData.vote = null;
          });
        }
      });
    }
  }

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
    final userInfos = Provider.of<UserInfo>(context, listen: false);
    List<String> favoritesID;

    _animControllerUp = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        lowerBound: 0.5,
        upperBound: 0.7);
    _animControllerDown = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        lowerBound: 0.5,
        upperBound: 0.7);
    _animUp = CurvedAnimation(parent: _animControllerUp, curve: Curves.linear);
    _animDown =
        CurvedAnimation(parent: _animControllerDown, curve: Curves.linear);
    _images.images = [];
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

  void dispose() {
    _animControllerUp.dispose();
    _animControllerDown.dispose();
    super.dispose();
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
            InkWell(
              onTap: () => voteUp(),
              child: ScaleTransition(
                scale: _animUp,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.imageData.upVotes.toString(),
                          style: TextStyle(color: Colors.green, fontSize: 28)),
                      WidgetSpan(
                        child: Icon(
                          (widget.imageData.vote == "up")
                              ? Icons.arrow_drop_up
                              : Icons.keyboard_arrow_up,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text("${widget.imageData.imagesNbr} photos"),
            InkWell(
              onTap: () => voteDown(),
              child: ScaleTransition(
                scale: _animDown,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.imageData.downVotes.toString(),
                          style: TextStyle(color: Colors.red, fontSize: 28)),
                      WidgetSpan(
                        child: Icon(
                          (widget.imageData.vote == "down")
                              ? Icons.arrow_drop_down
                              : Icons.keyboard_arrow_down,
                          size: 28,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
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
