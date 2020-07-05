import 'package:flutter/material.dart';
import 'package:Malar_Ai/database/dbHelper.dart';
import 'package:Malar_Ai/database/model.dart';
import 'package:sqflite/sqflite.dart';
import 'saved_result_detail.dart';

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  DBHelper databaseHelper = DBHelper();
  List<Photo> resultList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (resultList == null) {
      resultList = List<Photo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Results"),
      ),
      body: getResultListView(),
    );
  }

  ListView getResultListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            margin: EdgeInsets.all(6),
            shadowColor: Colors.purple,
            color: Colors.white,
            elevation: 10.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.purple,
                child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.yellow,
                    child: Icon(Icons.person)),
              ),
              title: Text(
                this.resultList[position].name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              subtitle: Text(
                this.resultList[position].date,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showAlertDialog(context, this.resultList[position].id);
                  }),
              onTap: () {
                showDetail(this.resultList[position]);
              },
            ),
          );
        });
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initDb();
    dbFuture.then((db) {
      Future<List<Photo>> resultListFuture = databaseHelper.getPhotos();

      resultListFuture.then((newList) {
        setState(() {
          this.resultList = newList.reversed.toList();
          this.count = newList.length;
        });
      });
    });
  }

  void showDetail(Photo result) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ResultDetail(result);
    }));
    updateListView();
  }

  void _delete(int id) async {
    await databaseHelper.delete(id);
    updateListView();
  }

  void showAlertDialog(BuildContext context, id) {
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
              _delete(id);
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
