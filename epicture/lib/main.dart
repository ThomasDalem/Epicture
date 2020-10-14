import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        fontFamily: 'Arial',
        backgroundColor: Color(0xFF3C3C3C),
        primaryColorLight: Color(0xFF8c32fa),
        primaryColorDark: Color(0xFF5a1ea0),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {'/home': (_) => HomePage()},
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _url = "";

  @override
  void waitLoginResult() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    _url = result;
    log("Received URL is $_url");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
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
      if (mounted) {
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
