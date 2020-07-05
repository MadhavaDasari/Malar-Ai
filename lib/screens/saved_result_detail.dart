import 'package:flutter/material.dart';
import 'package:Malar_Ai/database/dbHelper.dart';
import 'package:Malar_Ai/database/model.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class ResultDetail extends StatelessWidget {
  final Photo result;
  ResultDetail(this.result);
  final DBHelper databaseHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details : "),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  share(context, result);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showAlertDialog(context);
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              leading: Text("Blood sample Image : ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple,
                  )),
            ),
            Card(
              color: Colors.yellow,
              elevation: 20,
              shadowColor: Colors.purple,
              child: Container(
                padding: EdgeInsets.all(10),
                height: 200,
                width: 350,
                child: Image.memory(
                  base64Decode(result.photoName),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              child: ListTile(
                leading: Text("Patients Name :",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple,
                    )),
                title: Text("${result.name}"),
              ),
            ),
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              child: ListTile(
                leading: Text("Result :",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple,
                    )),
                title: Text("${result.result}"),
              ),
            ),
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              child: ListTile(
                leading: Text("Percentage Of Accuracy :",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                    )),
                title: Text("${result.prob}"),
              ),
            ),
            Card(
              elevation: 20,
              shadowColor: Colors.purple,
              child: ListTile(
                leading: Text("Tested On:",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple,
                    )),
                title: Text("${result.date}"),
              ),
            ),
          ],
        ));
  }

  share(BuildContext context, result) {
    final RenderBox box = context.findRenderObject();
    var date = (DateFormat.yMMMd().format(DateTime.now())).toString() +
        " , " +
        (DateFormat('hh:mm a').format(DateTime.now())).toString();
    print(date);
    Share.share(
        "*** Malar-Ai ***\n Blood Sample Test Results :\n Name :${result.name}\n Result : ${result.result} \n Percentage of Accuracy :${result.prob} \n Tested  on:$date",
        subject: "Malra-Ai Prediction",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _delete(int id, context) async {
    Navigator.pop(context);
    await databaseHelper.delete(id);
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Text("Confrim : "),
      content: Text("Are you Sure to Delete this Result ? "),
      actions: <Widget>[
        FlatButton(
            padding: EdgeInsets.only(right: 80),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 20),
            )),
        FlatButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              Navigator.of(context).pop();
              _delete(result.id, context);
            },
            child: Text(
              'Delete',
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
