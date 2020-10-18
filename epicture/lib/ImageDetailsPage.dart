import 'package:flutter/material.dart';

import 'CustomProfilAppBarButton.dart';
import 'JsonImageParser.dart';

class ImageDetailsPage extends StatefulWidget {
  final ImageData imageData;

  ImageDetailsPage({@required this.imageData});

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.imageData.upVotes);
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
                  itemBuilder: (context, index) =>
                      Image.network(widget.imageData.imagesInfos[index].url, fit: BoxFit.contain)))
        ]));
  }
}
