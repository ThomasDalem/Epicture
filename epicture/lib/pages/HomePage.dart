import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/UserInfo.dart';
import '../widgets/CustomProfilAppBarButton.dart';
import '../parsers/JsonImageParser.dart';
import '../widgets/SearchBar.dart';
import '../widgets/ImageWidget.dart';
import '../widgets/SingleImageWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ImageData> _images = [];
  int _sectionValue = 1;
  int _sortValue = 1;
  int _windowValue = 1;
  List<String> _sectionTitleItem = ["hot", "top"];
  List<String> _sortTitleItem = ["viral", "top", "time"];
  List<String> _windowTitleItem = ["day", "week", "month", "year", "all"];

  void getAccountAvatar() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get("https://api.imgur.com/3/account/" + userInfos.accountUsername,
        headers: {
          "Authorization": "Bearer " + userInfos.accessToken,
        }).then((response) {
      if (response.statusCode == 200) {
        var values = json.decode(response.body);
        var data = values['data'];
        Provider.of<UserInfo>(context, listen: false).getAvatar(data['avatar']);
      }
    });
  }

  void getGalleryImageWithoutSearchQuery() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get("https://api.imgur.com/3/gallery/hot/viral/", headers: {
      "Authorization": "Bearer ${userInfos.accessToken}"
    }).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _images = parseData(response.body).data;
          for (var image in _images) {
            if (image.isAlbum == false) {
              print('WOWOWOW');
            }
          }
        });
      }
    });
  }

  void getGalleryImageWithSearchQuery() {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    http.get(
        "https://api.imgur.com/3/gallery/search/" +
            _sortTitleItem[_sortValue] +
            "/" +
            _windowTitleItem[_windowValue] +
            "/?q=" +
            userInfos.querySearchImage,
        headers: {
          "Authorization": "Bearer ${userInfos.accessToken}"
        }).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _images = parseData(response.body).data;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    if (userInfos.avatarUrl == "") getAccountAvatar();
    if (userInfos.querySearchImage == "")
      getGalleryImageWithoutSearchQuery();
    else
      getGalleryImageWithSearchQuery();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColorLight,
                Color(0xFF3D156B)
              ],
            ),
          ),
        ),
        title: Text('Home Page'),
        leading: CustomProfilAppBarButton(
          redirect: true,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          if (_images[index].isAlbum == false) {
            return SingleImageWidget(data: _images[index]);
          } else {
            return ImageWidget(data: _images[index]);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        icon: Icon(Icons.arrow_drop_up),
                        iconEnabledColor: Color(0xFFFFFFFF),
                        dropdownColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        value: _sectionValue,
                        items: [
                          DropdownMenuItem(child: Text("hot"), value: 1),
                          DropdownMenuItem(child: Text("top"), value: 2),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sectionValue = value;
                            getGalleryImageWithoutSearchQuery();
                          });
                        }),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        icon: Icon(Icons.arrow_drop_up),
                        iconEnabledColor: Color(0xFFFFFFFF),
                        dropdownColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        value: _sortValue,
                        items: [
                          DropdownMenuItem(child: Text("viral"), value: 1),
                          DropdownMenuItem(child: Text("time"), value: 2),
                          DropdownMenuItem(child: Text("top"), value: 3),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortValue = value;
                            getGalleryImageWithoutSearchQuery();
                          });
                        }),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        icon: Icon(Icons.arrow_drop_up),
                        iconEnabledColor: Color(0xFFFFFFFF),
                        dropdownColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        value: _windowValue,
                        items: [
                          DropdownMenuItem(child: Text("day"), value: 1),
                          DropdownMenuItem(child: Text("week"), value: 2),
                          DropdownMenuItem(child: Text("month"), value: 3),
                          DropdownMenuItem(child: Text("year"), value: 4),
                          DropdownMenuItem(child: Text("all"), value: 5),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _windowValue = value;
                            getGalleryImageWithoutSearchQuery();
                          });
                        }),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
