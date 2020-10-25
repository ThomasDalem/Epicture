import 'package:flutter/material.dart';

Widget doComments(List<String> comments, List<String> authors, context) {
  List<Comments> data = List<Comments>();

  for (int i = 0; i < comments.length && i < authors.length; i++) {
    data.add(new Comments(author: authors[i], text: comments[i],));
  }
  return (
    Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: data
      ,)
    )
  );
}

class Comments extends StatelessWidget {
  final String author;
  final String text;

  Comments({this.author, this.text});

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: Column(children: <Widget>[
          Container (
            margin: EdgeInsets.all(4),
            child: Text(this.author + " :", style: TextStyle(color: Color(0xFFFFFFFF), decoration: TextDecoration.underline),),
          ),
          Container (
            width: MediaQuery.of(context).size.width,
            child: Text(this.text, style: TextStyle(color: Color(0xFFFFFFFF)),  softWrap: true,),
          )
        ],),
      )
    );
  }
}