import 'package:flutter/material.dart';

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
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Username or email'),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              RaisedButton(
                onPressed: () {},
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}