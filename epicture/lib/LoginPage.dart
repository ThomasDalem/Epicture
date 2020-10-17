import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import 'UserInfo.dart';
import 'HomePage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var _url = "";

  void waitLoginResult() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    _url = result;
    if (_url == null) {
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
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
        Provider.of<UserInfo>(context, listen: false).logUser(url);
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
      url:
          "https://api.imgur.com/oauth2/authorize?client_id=8cd66f037fcd783&response_type=token",
      appBar: new AppBar(title: new Text("Connection to Imgur")),
    );
  }
}
