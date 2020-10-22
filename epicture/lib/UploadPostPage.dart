import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CustomProfilAppBarButton.dart';
import 'UserInfo.dart';
import 'HomePage.dart';

class UploadPostPage extends StatefulWidget {
  @override
  _UploadPostPageState createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _image = null;
  final _imagePicker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  Future getImageFromFile() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  void tryToUploadNewPost() async {
    final userInfos = Provider.of<UserInfo>(context, listen: false);

    if (_formKey.currentState.validate() && _image != null) {
      http.post("https://api.imgur.com/3/upload", headers: {
        "Authorization": "Bearer ${userInfos.accessToken}"
      }, body: {
        "image": base64Encode(await _image.readAsBytes()),
        "video": "",
        "album": "",
        "type": "base64",
        "name": "",
        "title": _titleController.text,
        "description": _descriptionController.text,
        "disable_audio": "1",
      }).then((response) {
        if (response.statusCode == 200) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text('Upload Post'),
        actions: [CustomProfilAppBarButton(redirect: false)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(14),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: TextFormField(
                controller: _titleController,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                decoration: InputDecoration(
                  labelText: 'Tilte',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a title';
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                decoration: InputDecoration(
                  labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a description';
                  return null;
                },
              ),
            ),
            _image == null
                ? Container(
                    margin: EdgeInsets.fromLTRB(14, 28, 14, 14),
                    child: Text('No image selected',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight)))
                : Container(
                    margin: EdgeInsets.all(14),
                    height: 170,
                    width: 170,
                    child: Image.file(_image),
                  ),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                      onPressed: getImageFromCamera,
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(Icons.photo_camera)),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: getImageFromFile,
                    color: Theme.of(context).primaryColorLight,
                    icon: Icon(Icons.photo),
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.fromLTRB(100, 8, 100, 4),
                child: MaterialButton(
                    minWidth: 50,
                    height: 34,
                    elevation: 3,
                    onPressed: tryToUploadNewPost,
                    color: Theme.of(context).primaryColorLight,
                    child: Text('Post',
                        style: TextStyle(color: Color(0xFFFFFFFF)))))
          ],
        ),
      ),
    );
  }
}
