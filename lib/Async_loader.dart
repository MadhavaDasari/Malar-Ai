import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:Malar_Ai/database/dbHelper.dart';
import 'package:Malar_Ai/database/model.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

ProgressDialog pr;

class Upload extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Upload(this.image);
  Photo result = Photo();
  final File image;
  DBHelper helper = DBHelper();
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await uploadImage(image),
      renderLoad: () => loading(),
      renderError: ([error]) => errorWidget(context),
      renderSuccess: ({data}) => showResult(context, data),
    );

    return Scaffold(body: Center(child: _asyncLoader));
  }

  Widget errorWidget(context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 250.0,
          width: 300,
          child: new Container(
            child: Image.asset('assets/error.gif'),
          ),
        ),
        Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.error, color: Colors.purple),
              title: Text('Some Error has Occured !',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: Colors.purple),
              title: Text('Please Try Again Later '),
            ),
            ListTile(
              leading: Icon(Icons.wifi, color: Colors.purple),
              title: Text('Please Check Your Internet Connection '),
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
                          highlightColor: Colors.yellow[600],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.purple,
                          hoverColor: Colors.yellow,
                          child: Text("Go Back",
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
                          highlightColor: Colors.yellow[600],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () =>
                              asyncLoaderState.currentState.reloadState(),
                          color: Colors.purple,
                          hoverColor: Colors.yellow,
                          child: Text("Retry",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ]))
          ],
        ),
      ],
    );
  }

  // test() async {
  //   // make GET request
  //   String url = 'https://malar-ai.herokuapp.com/';
  //   Response response = await get(url);
  //   // sample info available in response
  //   print(response.statusCode);
  //   print(response.body);
  //   return response.body;
  // }

  // final time = const Duration(seconds: 10);

  // getMessage() async {
  //   return new Future.delayed(time, () => "error");
  // }

  Widget loading() {
    return Container(
      child: CircularPercentIndicator(
        footer: Text("Please Wait ", style: TextStyle(fontSize: 20)),
        header: new Text("Processing...", style: TextStyle(fontSize: 20)),
        radius: 180.0,
        backgroundColor: Colors.yellow,
        animationDuration: 30000,
        lineWidth: 8.0,
        animation: true,
        percent: 1,
        center: new Container(
            width: 140.0,
            height: 140.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/bots.jpg')))),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.purple,
      ),
    );
  }

  uploadImage(File photo) async {
    debugPrint("sent");
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
    if (r.statusCode == 503) {
      return "error";
    }
    var result = await r.stream.transform(utf8.decoder).join();
    var jd = jsonDecode(result);
    print(jd);
    return jd;
  }

  Widget showResult(context, jd) {
    if (jd == "error") {
      return errorWidget(context);
    } else if (jd["error"] != "0") {
      return errorWidget(context);
    }
    var test = jd["classification"];
    var probability = jd["probability"];
    probability = probability.substring(0, 5);

    var same = probability;
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text("Result"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    header: new Text(
                      "Level of Accuracy : ",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    radius: 180.0,
                    backgroundColor: Colors.yellow,
                    animationDuration: 2500,
                    lineWidth: 8.0,
                    animation: true,
                    percent: probability.substring(0, 2) != '10'
                        ? int.parse(probability.substring(0, 2)) / 100
                        : 1,
                    center: new Text(
                      "$same %",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.purple,
                  ),
                ),
                Card(
                  elevation: 20,
                  shadowColor: Colors.purple,
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                      color: Colors.purple,
                    ),
                    trailing: test == "Infected"
                        ? Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          ),
                    title: Text(
                      "Result : $test",
                      style: new TextStyle(
                        color: test == "Infected" ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
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
                          highlightColor: Colors.yellow[600],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () {
                            enterName(context, test, same, "Save");
                          },
                          color: Colors.purple,
                          hoverColor: Colors.yellow,
                          child: Text("Save",
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
                          highlightColor: Colors.yellow[600],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () {
                            // share(context, test, same);
                            enterName(context, test, same, "Share");
                          },
                          color: Colors.purple,
                          hoverColor: Colors.yellow,
                          child: Text("Share",
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
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
    );
  }

  share(BuildContext context, test, same, name) {
    final RenderBox box = context.findRenderObject();
    var date = (DateFormat.yMMMd().format(DateTime.now())).toString() +
        " , " +
        (DateFormat('hh:mm a').format(DateTime.now())).toString();
    print(date);
    Share.share(
        "*** Malar-Ai ***\n Blood Sample Test Results :\n Name :$name\n Result : $test \n Percentage of Accuracy :$same \n Tested  on:$date",
        subject: "Malra-Ai Prediction",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  enterName(context, test, same, method) async {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("$method As : ",
          style: TextStyle(fontSize: 20, color: Colors.purple)),
      content: new TextFormField(
        controller: nameController,
        autofocus: true,
        decoration: new InputDecoration(
          labelText: 'Patients Name :',
          hintText: 'eg. John Steve',
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            padding: EdgeInsets.only(right: 80),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 20, color: Colors.purple),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        new FlatButton(
            padding: EdgeInsets.all(20),
            child: Text('$method',
                style: TextStyle(fontSize: 20, color: Colors.purple)),
            onPressed: method == "Save"
                ? () async {
                    Navigator.pop(context);
                    _save(image, nameController.text, test, same);
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Saved the Result SuccesFully !'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                : () async {
                    Navigator.pop(context);
                    share(context, test, same, nameController.text);
                  })
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _save(File image, name, test, prob) async {
    String imgString = base64Encode(image.readAsBytesSync());
    result.photoName = imgString;
    result.date = (DateFormat.yMMMd().format(DateTime.now())).toString() +
        " , " +
        (DateFormat('hh:mm a').format(DateTime.now())).toString();
    result.name = name;
    if (result.name.isEmpty) result.name = '(Unnamed)';
    result.prob = prob;
    result.result = test;

    await helper.save(result);
  }

  void showSnackBar(context) {
    final snackBar = SnackBar(
      content: Text('Succesfully Saved the Result !'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 20,
                shadowColor: Colors.purple,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Test  Again ?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    asyncLoaderState.currentState.reloadState();
                  },
                ),
              ),
              Card(
                elevation: 20,
                shadowColor: Colors.purple,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Choose a New Sample ?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )),
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
