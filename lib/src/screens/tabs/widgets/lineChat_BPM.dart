import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xiaomi_scale/xiaomi_scale.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

//List<double> _bpmList = convertoList();

class LineChartBPM extends StatefulWidget {
  // static final _bpmList = convertoList();
  @override
  _LineChartBPMState createState() => _LineChartBPMState();
}

class _LineChartBPMState extends State<LineChartBPM>
    with AutomaticKeepAliveClientMixin<LineChartBPM> {
  List<Color> gradientColors = [
    const Color(0xffff0011),
    const Color(0xfffc2c2c),
  ];

  bool showAvg = false;
  bool get wantKeepAlive => true;

  @override
  static List<double> _bpmList = [];
  Widget build(BuildContext context) {
    // _bpmList = convertoList();
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'BPM (dia)',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '';
              case 5:
                return '';
              case 8:
                return '';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '';
              case 3:
                return '';
              case 5:
                return '';
            }
            return '';
          },
          reservedSize: 0,
          margin: 5,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 50,
      minY: 0,
      maxY: 400,
      lineBarsData: [lineChartBarData()],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '';
              case 5:
                return '';
              case 8:
                return '';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 100,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 300,
      minY: 0,
      maxY: 500,
      lineBarsData: [lineChartBarData()],
    );
  }

  LineChartBarData lineChartBarData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var d = DateTime.now();
    var thisDay = DateTime(d.year, d.month, d.day);
    Timestamp timestamp = Timestamp.fromDate(thisDay); //To TimeStamp

    Query bpm_time = FirebaseFirestore.instance
        .collection('BatimentosCardiacos')
        .where('uid', isEqualTo: auth.currentUser.uid)
        .where("time", isGreaterThan: timestamp);

    Future<Null> bpm = bpm_time.get().then((querySnapshot) {
      //clear list
      _bpmList.clear();
      querySnapshot.docs.forEach((result) {
        //  print(result.data());

        int aux = result.data().values.skip(1).first;
        print(aux);

        if (aux >= 20) _bpmList.add(aux.toDouble());
        print("LIST:");
        print(_bpmList);
      });
    });

    List<FlSpot> spot = [];
    for (var i = 0; i < _bpmList.length; i++) {
      var x = i + 1;
      spot.add(FlSpot(x.toDouble(), _bpmList[i]));
    }
    print(spot);
    return LineChartBarData(
      spots: spot,
      isCurved: false,
      colors: gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }
}
/*
List<double> convertoList() {
  List<double> _bpmList = [];
  var d = DateTime.now();
  var thisDay = DateTime(d.year, d.month, d.day);
  Timestamp timestamp = Timestamp.fromDate(thisDay); //To TimeStamp

  Query bpm_time = FirebaseFirestore.instance
      .collection('BatimentosCardiacos')
      .where('uid', isEqualTo: auth.currentUser.uid)
      .where("time", isGreaterThan: timestamp);

  Future<Null> bpm = bpm_time.get().then((querySnapshot) {
    //clear list
    _bpmList.clear();
    print("#####: uma itera????o feita (BPM-LINE Chart");
    querySnapshot.docs.forEach((result) {
      //  print(result.data());

      int aux = result.data().values.skip(1).first;
      //print(aux);

      if (aux >= 20) _bpmList.add(aux.toDouble());
      //print("LIST:");
      //print(_bpmList);
    });
  });

  return _bpmList;
}
*/
