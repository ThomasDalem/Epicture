import 'package:flutter/material.dart';
import 'JsonImageParser.dart';

import 'ImageDetailsPage.dart';

class ImageWidget extends StatelessWidget {
  final ImageData data;

  ImageWidget({this.data});

  @override
  Widget build(BuildContext context) {
    if (data.imagesInfos == null || data.imagesInfos.length == 0 || data.imagesInfos[0].isAnimated) {
      return Container();
    }
    return Card(
        color: const Color(0xFF2D1F5D),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetailsPage(imageData: data)));
            },
            child: Column(children: <Widget>[
              Stack(alignment: Alignment.bottomCenter, children: [
                Image.network(
                  data.imagesInfos[0].url,
                  fit: BoxFit.contain,
                  colorBlendMode: BlendMode.dstIn,
                ),
                Positioned.fill(
                    child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black])),
                )),
                Positioned(
                    left: 10,
                    bottom: 20,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(data.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Row(children: [
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(text: data.upVotes.toString(), style: TextStyle(color: Colors.green)),
                            WidgetSpan(
                                child: const Icon(
                              Icons.keyboard_arrow_up,
                              size: 14,
                              color: Colors.green,
                            ))
                          ],
                        )),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(text: data.downVotes.toString(), style: TextStyle(color: Colors.red)),
                            WidgetSpan(
                                child: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                              color: Colors.red,
                            ))
                          ]),
                        )
                      ])
                    ]))
              ])
            ])));
  }
}
