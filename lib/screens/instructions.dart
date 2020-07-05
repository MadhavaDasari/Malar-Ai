import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  int _currentIndex = 0;
  List cardList = [Item1(), Item2(), Item3(), Item4(), Item5()];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow the Steps :"),
      ),
      body: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: 500.0,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              // pauseAutoPlayOnTouch: Duration(seconds: 10),
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: cardList.map((card) {
              return Builder(builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.blueAccent,
                    child: card,
                  ),
                );
              });
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(cardList, (index, url) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? Colors.blueAccent : Colors.grey,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.yellow,
            elevation: 20,
            shadowColor: Colors.purple,
            child: Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 350,
                child: Image.asset(
                  'assets/1.png',
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Step 1 : \nPress the cammera Icon to select the Blood Sample Image ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.yellow,
            elevation: 20,
            shadowColor: Colors.purple,
            child: Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 350,
                child: Image.asset(
                  'assets/3.png',
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Step 2 :\nTap the Test Button to start Testing or Remove Button to Select An Other Image",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.yellow,
            elevation: 20,
            shadowColor: Colors.purple,
            child: Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 350,
                child: Image.asset(
                  'assets/4.png',
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                " Step 3 : \nWait For A moment Until Your Request is  Being Processed ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.yellow,
            elevation: 20,
            shadowColor: Colors.purple,
            child: Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 350,
                child: Image.asset(
                  'assets/5.png',
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Step  4 : \nThen Appears the Final Result ,Tap the Save Button to save the Result or Share Button to Share the Result with others ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class Item5 extends StatelessWidget {
  const Item5({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.yellow,
            elevation: 20,
            shadowColor: Colors.purple,
            child: Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 350,
                child: Image.asset(
                  'assets/6.png',
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Info : \nEnter the Patients Name Before Saving Or Sharing and See your saved Results in Side Menu Option named 'Saved Results' ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
