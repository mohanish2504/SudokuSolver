
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }

}

class MyAppState extends State<MyApp>{
  File file;
  final url = Uri.parse("http://192.168.31.59:8888/");
  void _choose() async {
    PickedFile imgfile;
    imgfile = (await ImagePicker().getImage(source: ImageSource.camera));
    //imgfile = (await ImagePicker().getImage(source: ImageSource.gallery));

    file = File(imgfile.path);
    setState(() {

    });
  }
  void _upload() async {
    if (file == null) return;
    print(await file.length());
    Dio dio = new Dio();
    FormData formData =  FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path,filename:basename(file.path)),
    });
    dio.post(url.toString(), data: formData, options: Options(
        method: 'POST',
        responseType: ResponseType.plain // or ResponseType.JSON
    )).then((dynamic response) => print(response))
        .catchError((error) => print(error));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeBody(),
    );
  }

  Widget homeBody(){
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
          file == null
              ? Text('No Image Selected')
              : Image.file(file)
        ],
      ),
    );
  }

}