import 'package:flutter/material.dart';

import '../parsers/JsonImageParser.dart';
import '../pages/ImageDetailsPage.dart';
import 'VideoPlayerWidget.dart';

Widget chooseMediaPlayer(ImageData data) {
  if (data.imagesInfos[0].type == 'video/mp4') {
    return VideoPlayerWidget(videoLink: data.imagesInfos[0].mp4);
  } else if (data.imagesInfos[0].type.contains("video/")) {
    return Container();
  }
  return Image.network(
    data.imagesInfos[0].url,
    fit: BoxFit.contain,
    colorBlendMode: BlendMode.dstIn,
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

class ImageWidget extends StatelessWidget {
  final ImageData data;

  ImageWidget({this.data});

  @override
  Widget build(BuildContext context) {
    if (data.imagesInfos == null || data.imagesInfos.length == 0) {
      return Container();
    }
    return Card(
      color: const Color(0xFF2D1F5D),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDetailsPage(imageData: data),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                chooseMediaPlayer(data),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: data.upVotes.toString(),
                                    style: TextStyle(color: Colors.green)),
                                WidgetSpan(
                                  child: const Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: data.downVotes.toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                                WidgetSpan(
                                  child: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: data.imagesNbr.toString(),
                                    style: TextStyle(color: Colors.grey[600])),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.burst_mode,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
