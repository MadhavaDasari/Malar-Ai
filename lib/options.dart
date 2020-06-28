import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Malar_Ai/result.dart';
import 'dart:async';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 20,
          title: Text("Malar-Ai"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text("Upload the blood Sample Image ",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                ),
                decideImageView() ? imageView() : Text("Image Not Selected "),
              ],
            ),
          ),
        ));
  }

  openCammera() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      // maxHeight: 500,
      // maxWidth: 500);
    );
    setState(() {
      image = img;
    });
  }

  openGallery() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = img;
    });
  }

  bool decideImageView() {
    if (image == null)
      return false;
    else
      return true;
  }

  Widget imageView() {
    return Column(
      children: <Widget>[
        Image.file(
          image,
          width: 500,
          height: 300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  image = null;
                });
              },
              color: Colors.purple,
              hoverColor: Colors.yellow,
              child: Text("Remove",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            RaisedButton(
              onPressed: () {
                uploadImage(image);
              },
              color: Colors.purple,
              hoverColor: Colors.yellow,
              child: Text("Test",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        )
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Via :'),
      content: Container(
        width: double.maxFinite,
        height: 112,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "Camera",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                openCammera();
              },
            ),
            ListTile(
              title: Text(
                "Gallery",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                openGallery();
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 20),
            )),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  uploadImage(File photo) async {
    showToast(context);
    String urlApi = "https://malar-ai.herokuapp.com/classify";
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(urlApi));

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        photo.path,
      ),
    );

    http.StreamedResponse r = await request.send();
    print(r.statusCode);

    var result = await r.stream.transform(utf8.decoder).join();
    var jd = jsonDecode(result);
    var test = jd["classification"];
    var probability = jd["probability"];
    probability = probability.substring(0, 5);
    var same = probability;

    showResult(test, probability, same);
  }

  showResult(test, probability, same) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Result(test, probability, same);
    }));
  }

  static void showToast(BuildContext context) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(builder: (context) => ToastWidget());
    Overlay.of(context).insert(overlayEntry);
    Timer(Duration(seconds: 35), () => overlayEntry.remove());
  }
}

class ToastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      body: Center(
          child: Image.asset(
        'assets/t2.gif',
        fit: BoxFit.fill,
        height: 300,
      )),
    );
  }
}
