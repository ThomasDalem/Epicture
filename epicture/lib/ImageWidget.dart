import 'package:flutter/material.dart';
import 'JsonImageParser.dart';

class ImageWidget extends StatelessWidget {
  final ImageData data;

  ImageWidget({this.data});

  @override
  Widget build(BuildContext context) {
    if (data.imagesInfos.length == 0 || data.imagesInfos[0].isAnimated) {
      return Container();
    }
    return Card(
        color: const Color(0xFF2D1F5D),
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Image.network(data.imagesInfos[0].url, fit: BoxFit.contain),
          SizedBox(
              height: 65,
              child: Center(
                  child: Text(data.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                      textAlign: TextAlign.center)))
        ]));
  }
}
