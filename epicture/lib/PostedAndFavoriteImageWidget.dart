import 'package:flutter/material.dart';

import 'JsonPostedAndFavoriteImageParser.dart';

class PostedAndFavoriteImageWidget extends StatelessWidget {
  final PostedAndFavoriteImage data;

  PostedAndFavoriteImageWidget({this.data});

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
