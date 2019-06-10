import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserOptions();
  }
}

class UserOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserOptionsState();
  }
}

class UserOptionsState extends State<UserOptions> {
  File galleryFile;

  File cameraFile;

  @override
  Widget build(BuildContext context) {
    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {});
    }

    imageSelectorCamera() async {
      cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
       
      );
      print("You selected camera image : " + cameraFile.path);
      setState(() {});
    }

    return new Scaffold(
      body: new Builder(
        builder: (BuildContext context) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new RaisedButton(
                child: new Text('Select Image from Gallery'),
                onPressed: imageSelectorGallery,
              ),
              new RaisedButton(
                child: new Text('Select Image from Camera'),
                onPressed: imageSelectorCamera,
              ),
              displaySelectedFile(galleryFile),
              displaySelectedFile(cameraFile)
            ],
          );
        },
      ),
    );
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
      child: file == null
          ? new Text('')
          : new Image.file(file),
    );
  }
}