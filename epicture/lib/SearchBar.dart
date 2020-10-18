import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'UserInfo.dart';
import 'HomePage.dart';

class SearchBar extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {query = "";},
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

 @override
  Widget buildResults(BuildContext context) {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    userInfos.getQuerySearchImage(query);
    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile();
        },
      );
  }
}