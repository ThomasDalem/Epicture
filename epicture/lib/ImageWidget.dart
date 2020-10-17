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
    return Image.network(data.imagesInfos[0].url);
  }
}
