import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'UserInfo.dart';

//String getAccessToken(String url) {}

String accessToken;
String refreshToken;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class MyImage {
  final String link;

  MyImage({this.link});

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      link: json['link'] as String,
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<Image> listImage = [
          Image.network('https://picsum.photos/250?image=9'),
          Image.network('https://picsum.photos/250?image=1'),
          Image.network('https://picsum.photos/250?image=2'),
          Image.network('https://picsum.photos/250?image=8'),
  ];

  @override
  void initState() {
    http.get("https://api.imgur.com/3/gallery/hot/viral/0.json",
      headers: {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "token_type": "Bearer",
        "account_username": "Skytaxx",
      }).then((response) {
      //print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        //var data = json.decode(response.body);
        //var rest = data["link"] as String;
        //var myImage = MyImage.fromJson(jsonDecode(response.body));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: ListView(
        children: listImage,
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var _url = "";

  void waitLoginResult() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    _url = result;
    if (_url == null) {
      return;
    }
    log("Received URL is $_url");
    UserInfo.accountUsername = "Thomas";
    accessToken = _url.substring(56, 96);
    refreshToken = _url.substring(150, 190);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Page'),
      ),
      backgroundColor: Color(0xFF3C3C3C),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            waitLoginResult();
          },
          child: const Text("Log in"),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<String> _onURLChanged;
  final _history = [];

  @override
  void initState() {
    super.initState();

    _onURLChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted &&
          url !=
              "https://api.imgur.com/oauth2/authorize?client_id=8cd66f037fcd783&response_type=token") {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
        Navigator.pop(context, url);
      }
    });
  }

  void dispose() {
    _onURLChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: "https://api.imgur.com/oauth2/authorize?client_id=8cd66f037fcd783&response_type=token",
      appBar: new AppBar(title: new Text("Connection to Imgur")),
    );
  }
}
