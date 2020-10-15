import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'UserInfo.dart';

String getAccessToken(String url) {}

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
    //print("access = " + await storage.read(key: 'access_token'));
    //print("access = " + await storage.read(key: 'refresh_token'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StartPage'),
      ),
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
      appBar: new AppBar(title: new Text("Connection à Imgur")),
    );
  }
}
