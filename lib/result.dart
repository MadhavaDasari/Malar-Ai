import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Result extends StatelessWidget {
  final String test;
  final String prob;
  final String same;
  Result(this.test, this.prob, this.same);

  @override
  Widget build(BuildContext context) {
    debugPrint(prob);
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Center(
        child: new CircularPercentIndicator(
          header: new Text(
            "Percent Probability : ",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          radius: 180.0,
          backgroundColor: Colors.yellow,
          animationDuration: 2500,
          lineWidth: 8.0,
          animation: true,
          percent: int.parse(prob.substring(0, 3)) / 100,
          center: new Text(
            "$same %",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          footer: new Text(
            test,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.purple,
        ),
      ),
    );
  }
}
