import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:async_loader/async_loader.dart';
import 'package:Malar_Ai/Async_loader.dart';
import 'package:Malar_Ai/side_menu.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  double percentage = 0.0;
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  File image;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      textDirection: TextDirection.rtl,
      isDismissible: true,
    );

    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          centerTitle: true,
          elevation: 20,
          title: Text("Malar-Ai"),
        ),
        body: Center(
          child: Container(
            // padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 40,
                  shadowColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0))),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                  color: Colors.purple,
                  child: ListTile(
                      title: Text("Upload the Blood Sample Image :",
                          style: TextStyle(color: Colors.white, fontSize: 15))),
                ),
                CircleAvatar(
                  backgroundColor: Colors.yellow[600],
                  radius: 30,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      showAlertDialog(context);
                    },
                  ),
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
        Card(
          color: Colors.yellow[600],
          elevation: 20,
          shadowColor: Colors.purple,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.file(
              image,
              width: 600,
              fit: BoxFit.fill,
              height: 300,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 50,
                width: 120,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () {
                    setState(() {
                      image = null;
                    });
                  },
                  color: Colors.purple,
                  highlightColor: Colors.yellow[600],
                  child: Text("Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
              ),
              Container(
                height: 50,
                width: 120,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Upload(image);
                    }));
                  },
                  color: Colors.purple,
                  highlightColor: Colors.yellow[600],
                  child: Text("Test",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      elevation: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(' Choose an Option:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      content: Container(
        width: double.maxFinite,
        height: 130,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.purple,
                ),
                title: Text(
                  "Camera",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  openCammera();
                },
              ),
            ),
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.image,
                  color: Colors.purple,
                ),
                title: Text(
                  "Gallery",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  openGallery();
                },
              ),
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
}
